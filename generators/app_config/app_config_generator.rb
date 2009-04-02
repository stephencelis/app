class AppConfigGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      m.file "app.yml", "config/app.yml"
    end
  end
end
