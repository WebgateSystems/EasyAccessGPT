# frozen_string_literal: true

module EasyAccessGpt
  class Filter < Request
    def initialize(message)
      super
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
        messages: [settings_chat, settings_message]
      }
    end

    def settings_chat
      {
        role: 'system',
        content: 'you will be the moderator of the text that I will send you,
                  you will return json only if there is profanity or insults
                  example answer: { message_include_profanity: true if there is false if not } okay?'
      }
    end

    def settings_message
      {
        role: 'user',
        content: "text: #{@message}, return only json without comments,
                  example answer: { message_include_profanity: true if there is false if not } okay?"
      }
    end
  end
end
