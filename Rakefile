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

namespace :gem do
  def run(command)
    puts "+ #{command}"
    result = system(command)
    puts "- #{result}"
  end
  desc "Release to rubygems"
  task :release do
    require File.expand_path('lib/truncate_html/version', File.dirname(__FILE__))
    version = TruncateHtml::VERSION
    message = "Bump to version #{version}"
    run "git tag -a -m '#{message}' v#{version}"
    run "git push origin master"
    run "git push origin $(git tag | tail -1)"
    run "gem build truncate_html.gemspec"
    run "gem push truncate_html-#{version}.gem"
    run "rm truncate_html-#{version}.gem"
  end
end
