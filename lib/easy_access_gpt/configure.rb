# frozen_string_literal: true

module EasyAccessGpt
  class Configure
    class << self
      attr_accessor :api_key, :gpt_model, :available_locales, :max_tokens, :model_url

      def gpt_model
        @gpt_model ||= Constants::DEFAULT_GPT_MODEL
      end

      def available_locales
        @available_locales ||= Constants::DEFAULT_LOCALES
      end

      def max_tokens
        @max_tokens ||= Constants::MAX_TOKENS
      end

      def model_url
        @model_url ||= Constants::DEFAULT_MODEL_URL
      end
    end
  end
end
