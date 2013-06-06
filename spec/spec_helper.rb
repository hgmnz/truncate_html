ENV["RAILS_ENV"] ||= 'test'
rails_root = File.expand_path('../rails_root', __FILE__)
require rails_root + '/config/environment.rb'

require 'rspec/rails'

require File.expand_path('../../lib/truncate_html', __FILE__)

RSpec.configure do |config|
  config.mock_with :rspec

  config.order = 'random'
end
