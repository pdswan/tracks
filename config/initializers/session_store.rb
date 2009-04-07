# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_tracks.pdswan.com_session',
  :secret      => '20b9f501628e55d9c62dd2a4b4a7c3fb82f3420f99844ade6ad0c7502756db6016cee2556c881d776771368cdfa30021781f144e59d3dc15bbffef9524ffb4db'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
