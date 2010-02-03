require 'truncate_html'

TruncateHtml.configure do |config|
  config.length   = 100
  config.omission = '...'
end
