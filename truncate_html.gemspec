# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "truncate_html/version"

Gem::Specification.new do |s|
  s.name        = "truncate_html"
  s.version     = TruncateHtml::VERSION
  s.authors     = ["Harold Giménez"]
  s.email       = ["harold.gimenez@gmail.com"]
  s.homepage    = "https://github.com/hgimenez/truncate_html"
  s.summary     = %q{Uses an API similar to Rails' truncate helper to truncate HTML and close any lingering open tags.}
  s.description = %q{Truncates html so you don't have to}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.9'

  s.add_development_dependency "rspec-rails", "~> 2.9"
  s.add_development_dependency "rails", "~> 3.0.3"
end
