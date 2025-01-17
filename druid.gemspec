# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "druid/version"

Gem::Specification.new do |s|
  s.name = "druid-s"
  s.platform = Gem::Platform::RUBY
  s.version = Druid::VERSION
  s.date = '2024-01-16'
  s.authors = ["Amber Yuan"]
  s.homepage = "https://github.com/amber-yuan/druid-s"
  s.summary = %q{Druid DSL for browser testing}
  s.description = %q{Druid DSL that works with Watir}
  s.license = 'MIT'
  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(pkg|spec|features|coverage)/})}
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f)}
  s.require_paths = ["lib"]
  s.add_dependency "watir", "~> 7.3.0"

  s.add_development_dependency "rspec", "~> 3.10"
  s.add_development_dependency "cucumber", "~> 9.0"
  s.add_development_dependency "net-http-persistent", "~> 4.0"
  s.add_development_dependency 'rack', '~> 3.0'
  s.add_development_dependency 'rackup', '~> 2.1'

  s.add_runtime_dependency 'page_navigation', '~> 0.10'

end
