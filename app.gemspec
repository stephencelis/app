# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{app}
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Stephen Celis"]
  s.date = %q{2009-04-17}
  s.description = %q{Move the config out of your app, and into App. Sure, it's been done before, and others will do it again, but this is my way, and I like it.}
  s.email = ["stephen@stephencelis.com"]
  s.extra_rdoc_files = ["History.rdoc", "Manifest.txt", "README.rdoc"]
  s.files = ["History.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "generators/app_config/app_config_generator.rb", "generators/app_config/templates/app.yml", "install.rb", "lib/app.rb", "test/app_test.rb", "test/fixtures/app/authenticate/basic/config.yml", "test/fixtures/app/authenticate.yml", "test/fixtures/app.yml"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{app}
  s.rubygems_version = %q{1.3.2}
  s.summary = %q{Move the config out of your app, and into App}
  s.homepage = "http://github.com/stephencelis/app"

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.12.0"])
    else
      s.add_dependency(%q<hoe>, [">= 1.12.0"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.12.0"])
  end
end
