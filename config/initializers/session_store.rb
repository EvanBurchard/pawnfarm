# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_pawnfarm_session',
  :secret      => '52078564d0cf99e400db202062da4cac9336a5287bc4fa7723c4a1781b1a90371291e24abe991cd09d5ac85739b49776a83ad6489a0acd39534a473d0c81ab8d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
