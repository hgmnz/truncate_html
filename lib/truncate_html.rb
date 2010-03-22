require File.join(File.dirname(__FILE__), 'truncate_html', 'html_truncator')
require File.join(File.dirname(__FILE__), 'truncate_html', 'html_string')
require File.join(File.dirname(__FILE__), 'truncate_html', 'configuration')
require File.join(File.dirname(__FILE__), 'app', 'helpers', 'truncate_html_helper')

ActionView::Base.class_eval do
  include TruncateHtmlHelper
end
