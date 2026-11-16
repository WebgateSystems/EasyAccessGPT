# frozen_string_literal: true

require_relative 'configure'

module EasyAccessGpt
  # Gives each Rack request a private configuration frame.
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      Configure.begin_request!
      @app.call(env)
    ensure
      Configure.end_request!
    end
  end
end
