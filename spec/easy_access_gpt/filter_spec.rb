# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EasyAccessGpt::Filter do
  let(:filter) { described_class }

  context 'when run filter without token' do
    it 'is return operation fail' do
      expect(filter.new('test').call[:operation]).to eql(:fail)
    end
  end

  context 'when run filter with wrong token' do
    before do
      EasyAccessGpt::Configure.api_key = 'test'
    end

    it 'is return operation fail' do
      expect(filter.new('test').call[:operation]).to eql(:fail)
    end
  end

  context 'when run filter with token' do
    let(:content) { { 'message_include_profanity:' => false }.to_json }
    let(:mock_answer) { { 'choices' => [{ 'message' => { 'content' => content } }] } }
    before do
      allow_any_instance_of(EasyAccessGpt::Request).to receive(:chat).and_return(mock_answer)
    end

    it 'is return operation success' do
      expect(filter.new('test').call).to eq({ 'message_include_profanity:' => false })
    end
  end
end
