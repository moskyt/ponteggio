# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ponteggio-test-app_session',
  :secret      => '9e5680ee2e8d2688388181f9bfb92ba0cbcfe93b5563408f6de552e59709a754877a8633854231380b122883b188f0b8f4edb3370c2421103f30894eee72d60f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
