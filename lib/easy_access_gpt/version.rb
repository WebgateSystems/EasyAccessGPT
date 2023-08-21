# frozen_string_literal: true

module EasyAccessGpt
  module VERSION
    MAJOR = 0
    MINOR = 2
    PATCH = 2
    BUILD = nil

    STRING = [MAJOR, MINOR, PATCH, BUILD].compact.join('.')

    def self.identify
      STRING
    end
  end
end
