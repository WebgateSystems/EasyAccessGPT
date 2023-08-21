# frozen_string_literal: true

module EasyAccessGpt
  module Constants
    DEFAULT_GPT_MODEL = 'gpt-3.5-turbo'
    DEFAULT_LOCALES = %i[de en es fr it pl ru ua].freeze
    MAX_TOKENS = 1000
    DEFAULT_MODEL_URL = '/v1/chat/completions'
  end
end
