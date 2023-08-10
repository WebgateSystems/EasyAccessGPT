# frozen_string_literal: true

module EasyAccessGpt
  class Request
    include HTTParty

    base_uri 'https://api.openai.com'

    def initialize(body, _locale = :en)
      @api_key = EasyAccessGpt::Configure.api_key
      @model_url = EasyAccessGpt::Configure.model_url
      @body = body
    end

    def chat
      self.class.post(@model_url, headers: headers, body: @body.to_json)
    end

    protected

    def parse_answer
      JSON.parse(@answer.dig('choices', 0, 'message', 'content'))
    end

    def fail!
      @answer.merge(operation: :fail)
    end

    private

    def headers
      {
        'Authorization': "Bearer #{@api_key}",
        'Content-Type': 'application/json'
      }
    end
  end
end
