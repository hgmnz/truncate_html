begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base app"
  exit
end

plugin_spec_dir = File.dirname(__FILE__)
require File.join(File.dirname(__FILE__), '..', 'lib', 'app', 'helpers', 'truncate_html_helper')
