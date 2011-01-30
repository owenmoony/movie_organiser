# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_movie_organiser_session',
  :secret      => 'a352773691c8eaeac2aafc630944fb3b5c003012c1c5d37dfc87aa50be7af37a1dda6cd303f71068b0b57622662a4f737597d1500072a9d56d54d48efecdf68b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
