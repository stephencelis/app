app_yaml = Rails.root.join("config", "app.yml")
if File.exist? app_yaml
  print 'Also remove "config/app.yml"? [yN] '
  if STDIN.gets.chomp =~ /^y)/i
    File.delete app_yaml
  end
end
