require File.join(File.dirname(__FILE__), 'truncate_html', 'version')
require File.join(File.dirname(__FILE__), 'truncate_html', 'html_truncator')
require File.join(File.dirname(__FILE__), 'truncate_html', 'html_string')
require File.join(File.dirname(__FILE__), 'truncate_html', 'configuration')
require File.join(File.dirname(__FILE__), 'app', 'helpers', 'truncate_html_helper')

TruncateHtml.configure do |config|
  config.length        = 100
  config.omission      = '...'
  config.word_boundary = /\S/
end

if defined?(ActionController)
  ActionController::Base.helper(TruncateHtmlHelper)
  ActionView::Base.send(:include, TruncateHtmlHelper)
end
