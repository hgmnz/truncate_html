require 'truncate_html'

TruncateHtml.configure do |config|
  config.length       = 100
  config.omission     = '...'
  config.word_boundary = true
end
