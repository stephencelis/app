# Provides configuration via superclass. Inherit from Configurable, and you
# have a handy little DSL/class for assigning/accessing your app settings.
#
#   class App < Configurable
#     config.launched_at = Time.now.utc
#   end
#
#   App.launched_at # => 2010-02-21 12:34:56 UTC
#
# Configurable classes will warn you when you call undefined settings.
#
#   App.typo # => nil
#   warning: undefined setting `typo' for App:Class
#
# If you don't care about these warnings, just redefine the logger.
#
#   App.configure do
#     config.logger = Logger.new nil
#   end
class Configurable
  autoload :Logger,     "logger"
  autoload :OpenStruct, "ostruct"

  class << self
    alias configure class_eval

    def [](key)
      config.respond_to? key or
        logger.warn "warning: undefined setting `#{key}' for #{name}:Class"

      config.send key
    end

    def inspect
      config.inspect.sub config.class.name, name
    end

    def logger
      return config.logger if config.respond_to? :logger
      return @logger if defined? @logger
      @logger ||= Rails.logger if defined? Rails
      @logger ||= Logger.new STDERR
    end

    def respond_to?(method_sym, include_private = false)
      config.respond_to?(method_sym) || super
    end

    private

    def config
      @config ||= OpenStruct.new
    end

    def config=(settings)
      @config = settings.is_a?(Hash) ? OpenStruct.new(settings) : settings
    end

    def method_missing(method, *args, &block)
      super if (key = method.to_s).end_with?("=")
      boolean = key.chomp!("?")
      value   = self[key]
      value   = value.call(*args, &block) if value.respond_to?(:call)
      boolean ? !!value : value
    end
  end

  if defined? Rails
    class Plugin < Rails::Railtie # :nodoc:
      class << self
        def load!
          require 'active_support/dependencies'
          pathname = Rails.root.join 'config', 'app'
          require_dependency pathname.to_s
          require_dependency pathname.join(Rails.env).to_s
        rescue NoMethodError => e
          Rails.logger.warn e
        rescue LoadError
        end
      end

      config.before_configuration { ::Configurable::Plugin.load! }
      config.to_prepare           { ::Configurable::Plugin.load! }
    end
  end
end
