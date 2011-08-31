# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{harmonia}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["James Adam"]
  s.date = %q{2011-08-31}
  s.email = %q{james@lazyatom.com}
  s.extra_rdoc_files = ["README"]
  s.files = ["Gemfile", "Gemfile.lock", "Rakefile", "README", "test/harmonia_test.rb", "test/test_helper.rb", "lib/harmonia.rb"]
  s.homepage = %q{http://yoursite.example.com}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.4.1}
  s.summary = %q{What this thing does}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mail>, ["~> 2.3.0"])
      s.add_runtime_dependency(%q<whenever>, ["~> 0.6.8"])
      s.add_runtime_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<mail>, ["~> 2.3.0"])
      s.add_dependency(%q<whenever>, ["~> 0.6.8"])
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<mail>, ["~> 2.3.0"])
    s.add_dependency(%q<whenever>, ["~> 0.6.8"])
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
