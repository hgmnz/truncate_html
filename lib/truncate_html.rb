path =  File.join(File.dirname(__FILE__), 'app', 'helpers')  
$LOAD_PATH << path 
ActiveSupport::Dependencies.load_paths << path 
ActiveSupport::Dependencies.load_once_paths.delete(path) 

ActionView::Base.class_eval do
  include TruncateHtmlHelper
end
