class AppConfigGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      if ARGV.empty?
        if File.exist? Rails.root.join("config", "app.yml")
          show_banner
        else
          m.file "app.yml", "config/app.yml"
        end
      else
        ARGV.each do |arg|
          path = "config/app/#{arg.underscore}"
          m.directory File.dirname(path)
          m.file "app.yml", "#{path}.yml"
        end
      end
    end
  end

  private

  def show_banner
    puts "App: you already have an app.yml!"
    puts
    puts "  Remember to pass arguments to generate new configurations:"
    puts "    script/generate app_config apis/twitter"
    puts
    puts "  Generates:"
    puts "    config/app/apis"
    puts "    config/app/apis/twitter.yml"
  end
end
