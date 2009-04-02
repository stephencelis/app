# App is your app.
#
# What would your app be without it? Still an app, but without the App.
module App
  VERSION = "0.1.0"

  raw_config = File.read Rails.root.join("config", "app.yml")
  @@config = YAML.load(ERB.new(raw_config).result)[Rails.env].freeze

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

    alias []       config
    alias __name__ name

    # Returns the name of the web application, which can be overridden in
    # "config/app.yml".
    #
    # To return the name of the module, use <tt>App.__name__</tt>.
    def name
      @@name ||= method_missing(:name) || File.basename(Rails.root)
    end

    def inspect
      "#<App: #{config.inspect}>"
    end

    private

    def method_missing(method, *args)
      self[method.to_s, *args] || self[method, *args]
    end
  end
end
