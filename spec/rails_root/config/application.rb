require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"

# Auto-require default libraries and those for the current Rails environment.
Bundler.require :default, Rails.env

module TruncateHtmlSpec
  class Application < Rails::Application
    config.active_support.deprecation = :stderr
    config.session_store :cookie_store, :key => "_myapp_session"
    config.secret_token = "truncate_html_super_secret_dont_tell_anyone"
  end
end
