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

  # Deprecated autoloads.
  autoload :ERB,        "erb"
  autoload :YAML,       "yaml"

  class << self
    alias __name__ name
    undef name

    alias configure class_eval

    def [](key)
      config.respond_to? key or
        logger.warn "warning: undefined setting `#{key}' for #{__name__}:Class"

      config.send key
    end

    def inspect
      config.inspect.sub config.class.name, __name__
    end

    def logger
      return config.logger if config.respond_to? :logger
      return @logger if defined? @logger
      @logger ||= Rails.logger if defined? Rails
      @logger ||= Logger.new STDERR
    end

    private

    def config
      @config ||= OpenStruct.new
    end

    def config=(settings)
      @config = case settings
      when String
        logger.warn "warning: YAML is deprecated (#{__FILE__}:#{__LINE__})"
        OpenStruct.new YAML.load(ERB.new(settings).result)
      when Hash
        OpenStruct.new settings
      else
        settings
      end
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
        rescue LoadError, NoMethodError => e
        end
      end

      config.before_configuration { ::Configurable::Plugin.load! }
      config.to_prepare           { ::Configurable::Plugin.load! }
    end
  end
end
