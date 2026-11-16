# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'EasyAccessGpt thread safety' do
  around do |example|
    configure = EasyAccessGpt::Configure
    previous = {
      api_key: configure.api_key,
      gpt_model: configure.gpt_model,
      available_locales: configure.available_locales,
      max_tokens: configure.max_tokens,
      model_url: configure.model_url
    }
    example.run
  ensure
    configure.reset_current!
    previous.each { |key, value| configure.public_send("#{key}=", value) }
  end

  def capture_authorization
    headers = Queue.new
    allow(EasyAccessGpt::Request).to receive(:post) do |*args, **kwargs|
      options = kwargs.empty? ? args.last : kwargs
      headers << options[:headers][:Authorization]
      { 'choices' => [{ 'message' => { 'content' => '{"ok":true}' } }] }
    end
    headers
  end

  it 'keeps keyword settings when another thread changes the process default' do
    headers = capture_authorization
    arrived = Queue.new
    start = Queue.new
    threads = %w[tenant-a tenant-b].map do |key|
      Thread.new do
        arrived << key
        start.pop
        EasyAccessGpt::Communication.new('hello', api_key: key).call
      end
    end
    2.times { arrived.pop }
    EasyAccessGpt::Configure.api_key = 'changed-by-another-thread'
    2.times { start << true }

    threads.each(&:join)
    expect(headers.size).to eq(2)
    expect([headers.pop, headers.pop]).to contain_exactly(
      'Bearer tenant-a',
      'Bearer tenant-b'
    )
  end

  it 'keeps a call on the settings object it was given' do
    headers = capture_authorization
    settings = EasyAccessGpt::Configure.snapshot(api_key: 'snapshot-key', max_tokens: 12)
    EasyAccessGpt::Configure.api_key = 'later-key'
    EasyAccessGpt::Filter.new('hello', config: settings).call

    expect(headers.pop).to eq('Bearer snapshot-key')
    expect(settings.max_tokens).to eq(12)
  end

  it 'isolates Configure assignments inside a request from other threads' do
    boot_key = EasyAccessGpt::Configure.api_key
    arrived = Queue.new
    start = Queue.new
    seen = Queue.new
    threads = %w[tenant-a tenant-b].map do |key|
      Thread.new do
        app = lambda do |_env|
          EasyAccessGpt::Configure.api_key = key
          EasyAccessGpt::Configure.gpt_model = "#{key}-model"
          arrived << key
          start.pop
          seen << [key, EasyAccessGpt::Configure.api_key, EasyAccessGpt::Configure.gpt_model]
          [200, {}, []]
        end
        EasyAccessGpt::Middleware.new(app).call({})
      end
    end
    2.times { arrived.pop }
    2.times { start << true }
    threads.each(&:join)

    expect([seen.pop, seen.pop]).to contain_exactly(
      ['tenant-a', 'tenant-a', 'tenant-a-model'],
      ['tenant-b', 'tenant-b', 'tenant-b-model']
    )
    expect(EasyAccessGpt::Configure.api_key).to eq(boot_key)
    expect(EasyAccessGpt::Configure.gpt_model).to eq('gpt-5.6-terra')
  end

  it 'drops request assignments before the next request on the same thread' do
    EasyAccessGpt::Configure.api_key = 'boot-key'
    leaking = lambda do |_env|
      EasyAccessGpt::Configure.api_key = 'tenant-a'
      raise 'boom'
    end
    expect { EasyAccessGpt::Middleware.new(leaking).call({}) }.to raise_error('boom')

    seen = nil
    reading = lambda do |_env|
      seen = EasyAccessGpt::Configure.api_key
      [200, {}, []]
    end
    EasyAccessGpt::Middleware.new(reading).call({})

    expect(seen).to eq('boot-key')
    expect(EasyAccessGpt::Configure.api_key).to eq('boot-key')
  end

  it 'restores the outer frame after with_settings' do
    boot_key = EasyAccessGpt::Configure.api_key
    EasyAccessGpt::Configure.begin_request!
    EasyAccessGpt::Configure.api_key = 'request-key'
    EasyAccessGpt::Configure.with_settings(api_key: 'block-key', max_tokens: 7) do
      expect(EasyAccessGpt::Configure.api_key).to eq('block-key')
      expect(EasyAccessGpt::Configure.max_tokens).to eq(7)
      EasyAccessGpt::Configure.with_settings(gpt_model: 'inner-model') do
        expect(EasyAccessGpt::Configure.api_key).to eq('block-key')
        expect(EasyAccessGpt::Configure.gpt_model).to eq('inner-model')
      end
      expect(EasyAccessGpt::Configure.gpt_model).to eq('gpt-5.6-terra')
    end
    expect(EasyAccessGpt::Configure.api_key).to eq('request-key')
    EasyAccessGpt::Configure.end_request!
    expect(EasyAccessGpt::Configure.api_key).to eq(boot_key)
  end

  it 'keeps fiber frames apart' do
    EasyAccessGpt::Configure.api_key = 'boot-key'
    first = Fiber.new do
      EasyAccessGpt::Configure.begin_request!
      EasyAccessGpt::Configure.api_key = 'fiber-a'
      Fiber.yield
      EasyAccessGpt::Configure.api_key
    ensure
      EasyAccessGpt::Configure.end_request!
    end
    second = Fiber.new do
      EasyAccessGpt::Configure.begin_request!
      EasyAccessGpt::Configure.api_key = 'fiber-b'
      Fiber.yield
      EasyAccessGpt::Configure.api_key
    ensure
      EasyAccessGpt::Configure.end_request!
    end

    first.resume
    second.resume
    expect(first.resume).to eq('fiber-a')
    expect(second.resume).to eq('fiber-b')
    expect(EasyAccessGpt::Configure.api_key).to eq('boot-key')
  end

  it 'copies locales so a caller cannot change another tenant array' do
    locales = %i[en]
    EasyAccessGpt::Configure.available_locales = locales
    locales << :pl

    expect(EasyAccessGpt::Configure.available_locales).to eq([:en])
    expect { EasyAccessGpt::Configure.available_locales << :de }.to raise_error(FrozenError)
  end

  it 'rejects unknown settings and a config that is not Settings' do
    expect { EasyAccessGpt::Communication.new('hello', nope: 1) }
      .to raise_error(ArgumentError, 'unknown settings: nope')
    expect { EasyAccessGpt::Configure.with_settings(nope: 1) { nil } }
      .to raise_error(ArgumentError, 'unknown settings: nope')
    expect { EasyAccessGpt::Configure.snapshot(config: 'nope') }
      .to raise_error(ArgumentError, 'config must be an EasyAccessGpt::Settings instance')
    settings = EasyAccessGpt::Configure.snapshot
    expect { EasyAccessGpt::Configure.snapshot(config: settings, api_key: 'x') }
      .to raise_error(ArgumentError, 'unknown settings: api_key')
    EasyAccessGpt::Configure.end_request!
  end

  it 'passes per-call settings through translation calls' do
    headers = capture_authorization
    EasyAccessGpt::Translation::SingleLocale.new('hello', :pl, api_key: 'single-key').call
    EasyAccessGpt::Translation::ScopeLocales.new('hello', api_key: 'scope-key', model_url: '/v1/other').call

    expect([headers.pop, headers.pop]).to contain_exactly(
      'Bearer single-key',
      'Bearer scope-key'
    )
  end
end
