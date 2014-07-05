Gem::Specification.new do |s|
  s.date = "2014-07-05"

  s.name = "app"
  s.version = "1.1.0"
  s.summary = "Application configuration."
  s.description = "Move the config out of your app, and into App."

  s.files = Dir["History.rdoc", "README.rdoc", "Rakefile", "lib/**/*"]

  s.extra_rdoc_files = %w(History.rdoc README.rdoc)
  s.has_rdoc = true
  s.rdoc_options = %w(--main README.rdoc)

  s.author = "Stephen Celis"
  s.email = "stephen@stephencelis.com"
  s.homepage = "http://github.com/stephencelis/app"
end
