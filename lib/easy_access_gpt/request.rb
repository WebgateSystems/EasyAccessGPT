# frozen_string_literal: true

module EasyAccessGpt
  class Request
    include HTTParty

    base_uri 'https://api.openai.com'

    def initialize(body)
      @api_key = EasyAccessGpt::Configure.api_key
      @body = body
    end

    def chat
      self.class.post('/v1/chat/completions', headers: headers, body: @body.to_json)
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
