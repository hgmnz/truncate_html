# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_truncate_html_session',
  :secret      => '1a04bc16ab110d1cb098e1508c72e000eab5059e9a73895e8b658dcd9316797a8d48cf5ac55ffd2cd7e1a66acdf1713856b78e677c089c1574f482e5c9fb21e9'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
