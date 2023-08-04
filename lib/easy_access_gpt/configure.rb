# frozen_string_literal: true

module EasyAccessGpt
  class Configure
    class << self
      attr_accessor :api_key, :gpt_model, :available_locales

      def gpt_model
        @gpt_model ||= Constants::DEFAULT_GPT_MODEL
      end

      def available_locales
        @available_locales ||= Constants::DEFAULT_LOCALES
      end
    end
  end
end
