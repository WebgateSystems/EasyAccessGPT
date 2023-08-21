# frozen_string_literal: true

module EasyAccessGpt
  class Communication < Request
    def initialize(message, settings = nil)
      super
      @message = message
      @settings ||= settings_chat
    end

    def call
      @answer = EasyAccessGpt::Request.new(body).chat
      @answer['error'] ? fail! : response
    end

    private

    def response
      @answer.dig('choices', 0, 'message', 'content')
    end

    def body
      {
        model: EasyAccessGpt::Configure.gpt_model,
        messages: [@settings, settings_message],
        max_tokens: EasyAccessGpt::Configure.max_tokens
      }
    end

    def settings_chat
      {
        role: 'system',
        content: 'You are a helpful assistant.'
      }
    end

    def settings_message
      {
        role: 'user',
        content: @message
      }
    end
  end
end
