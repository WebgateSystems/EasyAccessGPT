# frozen_string_literal: true

module EasyAccessGpt
  module Translation
    class ScopeLocales < Request
      def initialize(message)
        super
        @locales = EasyAccessGpt::Configure.available_locales
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
          content: 'you should translate text and return response as json'
        }
      end

      def settings_message
        {
          role: 'user',
          content: "This text: '#{@message}' translate to #{@locales}, translate only values but preserve keys.
                   Example answer: { locale => { key => translation }"
        }
      end
    end
  end
end
