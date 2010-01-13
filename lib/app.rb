# App is your app.
#
# What would your app be without it? Still an app, but without App.
module App
  VERSION = "0.2.2"

  @@config = if Object.const_defined?(:HashWithIndifferentAccess)
    HashWithIndifferentAccess.new
  else
    {}
  end
  class << self
    # Returns the application configuration hash, as defined in
    # "config/app.yml".
    #
    # Follows args through the hash tree. E.g.:
    #
    #   App.config("apis", "flickr") # => config_hash["apis"]["flickr"]
    #
    # <tt>App.config</tt> is aliased to <tt>App.[]</tt>, so shorten things up:
    #
    #   App["apis", "flickr"]
    #
    # Or rely on +method_missing+ to make it even shorter (and sweeter):
    #
    #   App.apis("flickr")
    def config(*args)
      @@config if args.empty?
      args.inject(@@config) { |config, arg| config[arg] }
    end
    alias [] config

    def inspect
      "#<#{name}: #{config.inspect}>"
    end

    private

    def method_missing(method, *args)
      self[method.to_s, *args] || self[method, *args]
    end
  end

  begin
    raw = File.read Rails.root.join("config", "#{name.underscore}.yml")
    all = YAML.load ERB.new(raw).result
    @@config.update(all[Rails.env] || all)
    @@config.freeze
  rescue Errno::ENOENT => e
    puts '** App: no file "config/app.yml". Run `script/generate app_config`.'
  end
end

unless __FILE__ == "(eval)"
  module App
    class << self
      # Returns the name of the web application.
      def to_s
        File.basename Rails.root
      end
    end
  end

  # Iterate through other App configs and namespace them.
  Dir[Rails.root.join("config", "app", "**/*.yml")].sort.each do |config|
    name = config.gsub(/#{Rails.root.join("config")}\/|\.yml/) {}.classify

    # Recognize all parents.
    line = name.split "::"
    line.inject do |parentage, descendant|
      eval "module #{parentage}; end"
      "#{parentage}::#{descendant}"
    end

    eval File.read(__FILE__).sub("module App", "module #{name}")
  end
end
