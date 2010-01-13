# Be sure to restart your server when you modify this file
ENV['RAILS_ENV'] = 'test'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.plugin_paths += %W(#{RAILS_ROOT}/../../..)
  config.plugins = [:ponteggio]

  config.time_zone = 'UTC'
  
  config.gem 'searchlogic'
  config.gem 'shoulda'
  config.gem 'factory_girl'
end