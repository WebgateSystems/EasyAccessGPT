# frozen_string_literal: true

module EasyAccessGpt
  # Frozen copy of the settings one call will use.
  class Settings
    attr_reader :api_key, :gpt_model, :available_locales, :max_tokens, :model_url

    def initialize(values)
      @api_key = values.fetch(:api_key)
      @gpt_model = values.fetch(:gpt_model)
      @available_locales = values.fetch(:available_locales)
      @max_tokens = values.fetch(:max_tokens)
      @model_url = values.fetch(:model_url)
      freeze
    end
  end
end
