# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EasyAccessGpt::Translation::SingleLocale do
  let(:translation) { described_class }

  context 'when run translate without token' do
    it 'is return operation fail' do
      expect(translation.new('test', 'test').call[:operation]).to eql(:fail)
    end
  end

  context 'when run translate with wrong token' do
    before do
      EasyAccessGpt::Configure.api_key = 'test'
    end

    it 'is return operation fail' do
      expect(translation.new('test', 'test').call[:operation]).to eql(:fail)
    end
  end

  context 'when run translate with token' do
    let(:content) { { 'en' => { 'text' => 'test' } }.to_json }
    let(:mock_answer) { { 'choices' => [{ 'message' => { 'content' => content } }] } }
    before do
      allow_any_instance_of(EasyAccessGpt::Request).to receive(:chat).and_return(mock_answer)
    end

    it 'is return operation success' do
      expect(translation.new('test', 'test').call).to eq({ 'en' => { 'text' => 'test' } })
    end
  end
end
