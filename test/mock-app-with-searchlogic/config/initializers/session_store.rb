# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mock-app_session',
  :secret      => 'ac2fc2e1758abcfd5374c7bf732e33f17754244641f95a88096d636b97c5f57889e55b77b4729c98d3dff670d5b84dd8de90fff5470787f61417562882c69710'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
