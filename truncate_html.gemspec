# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{truncate_html}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["hgimenez"]
  s.date = %q{2009-09-25}
  s.description = %q{Truncates html so you don't have to}
  s.email = %q{harold.gimenez@gmail.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    ".gitignore",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "init.rb",
     "install.rb",
     "lib/app/helpers/truncate_html_helper.rb",
     "lib/truncate_html.rb",
     "lib/truncate_html/html_truncator.rb",
     "spec/helpers/truncate_html_helper_spec.rb",
     "spec/spec_helper.rb",
     "spec/truncate_html/html_truncator_spec.rb",
     "tasks/truncate_html_tasks.rake",
     "truncate_html.gemspec",
     "uninstall.rb"
  ]
  s.homepage = %q{http://github.com/hgimenez/truncate_html}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Uses an API similar to Rails' truncate helper to truncate HTML and close any lingering open tags.}
  s.test_files = [
    "spec/helpers/truncate_html_helper_spec.rb",
     "spec/spec_helper.rb",
     "spec/truncate_html/html_truncator_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
