# frozen_string_literal: true

module EasyAccessGpt
  module Translation
    class SingleLocale < Request
      def initialize(message, locale)
        super
        @locale = locale
        @message = message
      end

      def call
        @answer = EasyAccessGpt::Request.new(body).chat
        @answer['error'] ? fail! : parse_answer
      end

      private

      def body
        {
          model: EasyAccessGpt::Configure.gpt_model,
          messages: [settings_chat, settings_message],
          max_tokens: EasyAccessGpt::Configure.max_tokens
        }
      end

      def settings_chat
        {
          role: 'system',
          content: 'you are a translator, translate and return responce as a json'
        }
      end

      def settings_message
        {
          role: 'user',
          content: "This text: '#{@message}' translate to #{@locale}, translate only values and return json"
        }
      end
    end
  end
end
