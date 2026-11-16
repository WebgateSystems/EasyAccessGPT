# frozen_string_literal: true

require 'rails/railtie'
require_relative 'middleware'

module EasyAccessGpt
  class Railtie < Rails::Railtie
    initializer 'easy_access_gpt.isolate_requests' do |app|
      app.middleware.insert_before 0, EasyAccessGpt::Middleware
    end
  end
end
