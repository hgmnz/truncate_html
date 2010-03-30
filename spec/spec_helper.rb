ENV["RAILS_ENV"] ||= 'test'
rails_root = File.dirname(__FILE__) + '/rails_root'
require rails_root + '/config/environment.rb'

require 'rspec/rails'

require File.join(File.dirname(__FILE__), '..', 'lib', 'truncate_html')

Rspec.configure do |config|
  config.mock_with :rspec
end
