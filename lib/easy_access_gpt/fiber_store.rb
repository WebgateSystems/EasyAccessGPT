# frozen_string_literal: true

module EasyAccessGpt
  # Per-fiber stack of configuration frames. Threads do not share fibers.
  module FiberStore
    KEY = :easy_access_gpt_frames

    module_function

    def current
      Fiber[KEY]&.last
    end

    def begin_request
      Fiber[KEY] = [{}]
    end

    def push(frame)
      stack = Fiber[KEY]
      Fiber[KEY] = (stack ? stack.dup : []) << frame
    end

    def replace_current(frame)
      copied = Fiber[KEY].dup
      copied[-1] = frame
      Fiber[KEY] = copied
    end

    def pop
      stack = Fiber[KEY]
      return if stack.nil? || stack.empty?

      remaining = stack[0...-1]
      Fiber[KEY] = remaining.empty? ? nil : remaining
    end

    def reset
      Fiber[KEY] = nil
    end
  end
end
