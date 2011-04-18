# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ubiquo}
  s.version = "0.4.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Albert Callarisa", "Bernat Foj", "Eric Garc\303\255a", "Felip Ladr\303\263n", "Antoni Reina", "Ramon Salvad\303\263", "Arnau S\303\241nchez"]
  s.date = %q{2011-04-18}
  s.default_executable = %q{ubiquo}
  s.description = %q{This gem provides a command-line interface to speed up the creation of ubiquo based apps.}
  s.email = %q{rsalvado@gnuine.com}
  s.executables = ["ubiquo"]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/ubiquo",
    "lib/ubiquo.rb",
    "lib/ubiquo/generator.rb",
    "lib/ubiquo/options.rb",
    "lib/ubiquo/template.erb",
    "test/fixtures/template.erb",
    "test/helper.rb",
    "test/ubiquo/generator_test.rb",
    "test/ubiquo/options_test.rb",
    "ubiquo.gemspec"
  ]
  s.homepage = %q{http://www.ubiquo.me}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{command line application for building ubiquo based applications.}
  s.test_files = [
    "test/helper.rb",
    "test/ubiquo/generator_test.rb",
    "test/ubiquo/options_test.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["= 2.3.11"])
      s.add_runtime_dependency(%q<i18n>, ["< 0.5.0"])
      s.add_runtime_dependency(%q<lockfile>, [">= 1.4.3"])
      s.add_runtime_dependency(%q<bundler>, [">= 1.0.10"])
      s.add_development_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_development_dependency(%q<highline>, [">= 1.5.2"])
      s.add_development_dependency(%q<ya2yaml>, [">= 0.26"])
    else
      s.add_dependency(%q<rails>, ["= 2.3.11"])
      s.add_dependency(%q<i18n>, ["< 0.5.0"])
      s.add_dependency(%q<lockfile>, [">= 1.4.3"])
      s.add_dependency(%q<bundler>, [">= 1.0.10"])
      s.add_dependency(%q<mocha>, [">= 0.9.8"])
      s.add_dependency(%q<highline>, [">= 1.5.2"])
      s.add_dependency(%q<ya2yaml>, [">= 0.26"])
    end
  else
    s.add_dependency(%q<rails>, ["= 2.3.11"])
    s.add_dependency(%q<i18n>, ["< 0.5.0"])
    s.add_dependency(%q<lockfile>, [">= 1.4.3"])
    s.add_dependency(%q<bundler>, [">= 1.0.10"])
    s.add_dependency(%q<mocha>, [">= 0.9.8"])
    s.add_dependency(%q<highline>, [">= 1.5.2"])
    s.add_dependency(%q<ya2yaml>, [">= 0.26"])
  end
end

