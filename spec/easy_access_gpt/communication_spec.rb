# frozen_string_literal: true

require 'spec_helper'

RSpec.describe EasyAccessGpt::Communication do
  let(:communication) { described_class }

  context 'when run communication without token' do
    it 'is return operation fail' do
      expect(communication.new('test').call[:operation]).to eql(:fail)
    end
  end

  context 'when run communication with wrong token' do
    before do
      EasyAccessGpt::Configure.api_key = 'test'
    end

    it 'is return operation fail' do
      expect(communication.new('test').call[:operation]).to eql(:fail)
    end
  end

  context 'when run communication with token' do
    let(:content) { 'Hello! How can I assist you today?'}
    let(:mock_answer) { { 'choices' => [{ 'message' => { 'content' => content } }] } }
    before do
      allow_any_instance_of(EasyAccessGpt::Request).to receive(:chat).and_return(mock_answer)
    end

    it 'is return operation success' do
      expect(communication.new('hello').call).to eq( 'Hello! How can I assist you today?' )
    end
  end
end
