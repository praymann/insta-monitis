# Version
require "insta-monitis/ver/version"

### Classes

# API interface
require "insta-monitis/api"

# Monitior definitions
require "insta-monitis/monitors.rb"

# Main class for insta-monitis ( API <-> Backend <-> Runner )
require "insta-monitis/backend"

# CLI class ( Thor )
require "insta-monitis/runner"

# Class to pull in configurations
require "insta-monitis/configurator"

