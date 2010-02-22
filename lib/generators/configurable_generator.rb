class ConfigurableGenerator < Rails::Generators::Base # :nodoc:
  def self.source_root
    @_configurable_source_root ||=
      File.expand_path("../#{base_name}/templates", __FILE__)
  end

  def install
    copy_file "app.rb", "config/app.rb"
    Dir[Rails.root.join("config", "environments", "*.rb").to_s].each do |env|
      template "app/env.rb", "config/app/#{File.basename env}"
    end
  end
end
