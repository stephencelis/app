class App < Configurable
  # Settings in config/app/* take precedence over those specified here.
  config.name = Rails::Application.instance.class.parent.name

  # config.key = "value"
end
