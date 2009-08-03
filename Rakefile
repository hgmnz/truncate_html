require 'rake'
require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour --format progress --loadby mtime --reverse']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "truncate_html"
    gem.summary = %Q{Uses an API similar to Rails' truncate helper to truncate HTML and close any lingering open tags.}
    gem.description = %Q{Truncates html so you don't have to}
    gem.email = "harold.gimenez@gmail.com"
    gem.homepage = "http://github.com/hgimenez/truncate_html"
    gem.authors = ["hgimenez"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end


