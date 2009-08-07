# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mycode_session',
  :secret      => 'e5d8c71b429d65350946c187627da21d1f9c8c245f8478a518c11148328662cb55cfb5627e732349aa5821aca03b7d668c59e96c1dbff2a001caacd1b43cf541'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
