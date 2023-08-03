# frozen_string_literal: true

module EasyAccessGpt
  class Translation < Request
    def initialize(message)
      super
      @locales = EasyAccessGpt::Configure.available_locales
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
        content: 'you are translate words and return only json'
      }
    end

    def settings_message
      {
        role: 'user',
        content: "#{@message} translate to #{@locales} translate only values and return json translate only values,
                  save keys, exsample answer: { locale => { key => translation }"
      }
    end
  end
end
