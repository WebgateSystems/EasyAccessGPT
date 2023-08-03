# frozen_string_literal: true

module EasyAccessGpt
  class Configure
    class << self
      attr_accessor :api_key

      def gpt_model(name = Constants::DEFAULT_GPT_MODEL)
        @gpt_model ||= name
      end

      def available_locales(locales = Constants::DEFAULT_LOCALES)
        @available_locales ||= locales
      end
    end
  end
end
