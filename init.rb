if !File.exist? Rails.root.join("config", "app.yml")
  puts '** App: "config/app.yml" not found. Run `script/generate app_config`.'
end
