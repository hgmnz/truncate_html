path =  File.join(File.dirname(__FILE__), 'app', 'helpers')  
$LOAD_PATH << path 
ActiveSupport::Dependencies.load_paths << path 
ActiveSupport::Dependencies.load_once_paths.delete(path) 

require File.join(File.dirname(__FILE__), 'truncate_html', 'html_truncator')

ActionView::Base.class_eval do
  include TruncateHtmlHelper
end
