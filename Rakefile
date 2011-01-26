require 'rake'

begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
rescue MissingSourceFile
  module RSpec
    module Core
      class RakeTask
        def initialize(name)
          task name do
            # if rspec-rails is a configured gem, this will output helpful material and exit ...
            require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
            # ... otherwise, do this:
            raise <<-MSG
#{"*" * 80}
*  You are trying to run an rspec rake task defined in
*  #{__FILE__},
*  but rspec can not be found in vendor/gems, vendor/plugins or system gems.
#{"*" * 80}
MSG
          end
        end
      end
    end
  end
end

task :default => :spec
task :stats => "spec:statsetup"

desc "Run RSpec code examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern   = "./spec/**/*_spec.rb"
end

begin
  require 'metric_fu'
  MetricFu::Configuration.run do |config|
    config.metrics  = [:saikuro, :flog, :flay, :reek, :roodi, :rcov]
    config.graphs   = [:flog, :flay, :reek, :roodi, :rcov]
    config.rcov     = { :environment => 'test',
                        :test_files => ['spec/**/*_spec.rb'],
                        :rcov_opts => ["--sort coverage",
                                       "--text-coverage",
                                       "--profile",
                                       "--exclude /gems/,/Library/"]}
    config.graph_engine = :bluff
  end
rescue LoadError
  puts "Install metric_fu to run code metrics"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "truncate_html"
    gem.summary = %Q{Uses an API similar to Rails' truncate helper to truncate HTML and close any lingering open tags.}
    gem.description = %Q{Truncates html so you don't have to}
    gem.email = "harold.gimenez@gmail.com"
    gem.homepage = "http://github.com/hgimenez/truncate_html"
    gem.authors = ["Harold A. Gimenez"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end
