# frozen_string_literal: true

module EasyAccessGpt
  class Communication < Request
    def initialize(message, **options)
      super(nil, config: EasyAccessGpt::Configure.snapshot(**options))
      @message = message
      @settings = settings_chat
    end

    def call
      @answer = EasyAccessGpt::Request.new(body, config: @config).chat
      @answer['error'] ? fail! : response
    end

    private

    def response
      message_content
    end

    def body
      model_options.merge(messages: [@settings, settings_message])
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
