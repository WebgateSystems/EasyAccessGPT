# frozen_string_literal: true

module EasyAccessGpt
  module Translation
    class ScopeLocales < Request
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
          content: 'you should translate text and return response as json'
        }
      end

      def settings_message
        {
          role: 'user',
          content: "This text: '#{@message}' translate to #{@config.available_locales}, " \
                   "translate only values but preserve keys.\n         " \
                   'Example answer: { locale => { key => translation }'
        }
      end
    end
  end
end
