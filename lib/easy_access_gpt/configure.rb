# frozen_string_literal: true

require_relative 'constants'
require_relative 'fiber_store'
require_relative 'settings'

module EasyAccessGpt
  # Process defaults, plus a private frame for the current thread or fiber.
  class Configure
    SETTINGS_KEYS = %i[api_key gpt_model available_locales max_tokens model_url].freeze
    MUTEX = Mutex.new

    class << self
      SETTINGS_KEYS.each do |key|
        define_method(key) { fetch(key) }
        define_method("#{key}=") { |value| assign(key, value) }
      end

      # Copy defaults and any current frame, then apply overrides.
      # The result does not change when another thread writes configuration.
      def snapshot(**overrides)
        explicit = explicit_config(overrides)
        return explicit if explicit

        values = MUTEX.synchronize { @defaults.dup }
        frame = FiberStore.current
        values.merge!(frame) if frame
        values.merge!(prepare_overrides(overrides))
        Settings.new(values)
      end

      def with_settings(**overrides)
        prepared = prepare_overrides(overrides)
        FiberStore.push((FiberStore.current || {}).merge(prepared))
        yield
      ensure
        FiberStore.pop if prepared
      end

      # Start a request from process defaults. The parent fiber keeps its own frames.
      def begin_request!
        FiberStore.begin_request
      end

      def end_request!
        FiberStore.pop
      end

      def reset_current!
        FiberStore.reset
      end

      private

      def fetch(key)
        frame = FiberStore.current
        return frame[key] if frame&.key?(key)

        MUTEX.synchronize { @defaults[key] }
      end

      def assign(key, value)
        frozen = freeze_setting(key, value)
        if (frame = FiberStore.current)
          FiberStore.replace_current(frame.merge(key => frozen))
        else
          MUTEX.synchronize do
            @defaults = @defaults.merge(key => frozen).freeze
          end
        end
      end

      def explicit_config(overrides)
        return nil unless overrides.key?(:config)

        extra = overrides.keys - [:config]
        raise ArgumentError, "unknown settings: #{extra.join(', ')}" if extra.any?

        config = overrides[:config]
        return config if config.is_a?(Settings)

        raise ArgumentError, 'config must be an EasyAccessGpt::Settings instance'
      end

      def prepare_overrides(overrides)
        unknown = overrides.keys - SETTINGS_KEYS
        raise ArgumentError, "unknown settings: #{unknown.join(', ')}" if unknown.any?

        overrides.to_h { |key, setting| [key, freeze_setting(key, setting)] }
      end

      def freeze_setting(key, value)
        case key
        when :api_key, :gpt_model, :model_url
          value.nil? ? nil : String(value).freeze
        when :max_tokens
          Integer(value)
        when :available_locales
          Array(value).map(&:to_sym).freeze
        end
      end

      def install_defaults!
        MUTEX.synchronize do
          @defaults = {
            api_key: nil,
            gpt_model: Constants::DEFAULT_GPT_MODEL.dup.freeze,
            available_locales: Constants::DEFAULT_LOCALES.dup.freeze,
            max_tokens: Constants::MAX_TOKENS,
            model_url: Constants::DEFAULT_MODEL_URL.dup.freeze
          }.freeze
        end
      end
    end

    install_defaults!
  end
end
