# frozen_string_literal: true

module EasyAccessGpt
  class Filter < Request
    def initialize(message, **options)
      super(nil, config: EasyAccessGpt::Configure.snapshot(**options))
      @message = message
    end

    def call
      @answer = EasyAccessGpt::Request.new(body, config: @config).chat
      @answer['error'] ? fail! : parse_answer
    end

    private

    def body
      model_options(json: true).merge(messages: [settings_chat, settings_message])
    end

    def settings_chat
      {
        role: 'system',
        content: 'You moderate text and return json only. ' \
                 'Set message_include_profanity to true when the text contains profanity or insults, ' \
                 'otherwise false. Example: {"message_include_profanity": false}'
      }
    end

    def settings_message
      {
        role: 'user',
        content: "text: #{@message}. Return json only, for example {\"message_include_profanity\": false}."
      }
    end
  end
end
