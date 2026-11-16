# frozen_string_literal: true

module EasyAccessGpt
  class Request
    include HTTParty

    base_uri 'https://api.openai.com'

    def initialize(body, config:)
      @config = config
      @api_key = config.api_key
      @model_url = config.model_url
      @body = body
    end

    def chat
      self.class.post(@model_url, headers:, body: @body.to_json)
    end

    protected

    def model_options(json: false)
      {
        model: @config.gpt_model,
        max_completion_tokens: @config.max_tokens,
        reasoning_effort: 'none'
      }.tap do |options|
        options[:response_format] = { type: 'json_object' } if json
      end
    end

    def message_content
      @answer.dig('choices', 0, 'message', 'content')
    end

    def parse_answer
      JSON.parse(message_content)
    end

    def fail!
      @answer.merge(operation: :fail)
    end

    private

    def headers
      {
        Authorization: "Bearer #{@api_key}",
        'Content-Type': 'application/json'
      }
    end
  end
end
