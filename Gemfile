# Uses rubygems.org as the default gem repo
source :rubygems

gem 'backports', '~> 2.8.2'

# Used for accessing documents over HTTP
require 'net/http'

# Used for easy date/time parsing
gem 'chronic', '~> 0.6.7'

# Converts .coffee scripts into .js scripts
#gem 'coffee-script', '~> 2.2.0'

# DataMapper is the default ORM
#   Be sure to comment/uncomment the adapters you plan on using
#   See also: ./settings/datamapper.rb
gem 'data_mapper', '~> 1.2.0'
gem 'dm-sqlite-adapter', '~> 1.2.0'
# gem 'dm-mysql-adapter', '~> 1.2.0'
# gem 'dm-postgres-adapter', '~> 1.2.0'

# Used for parsing JSON to and from Ruby objects
gem 'json', '~> 1.7.4'

# Used for sending emails
gem 'pony', '~> 1.4'

# Used for checking Image sizes 
gem 'fastimage'

# Used for temporary flash messages
gem 'rack-flash3', '~> 1.0.1', require: 'rack-flash'

# Used for parsing markdown into html
gem 'redcarpet', '~> 2.1.1'

# Used for converting .scss and .sass stylesheets into .css stylesheets
gem 'sass', '~> 3.1.19'

# Used for route handling, view rendering, helpers, etc.
gem 'sinatra', '~> 1.3.3'
gem 'sinatra-contrib', '~> 1.3.1'
require 'sinatra/namespace'

# Requires gems from vendor templates
#   Be careful - this can easily cause conflicts
Dir["./vendor/**/Gemfile"].each { |gemfile| self.send(:eval, File.open(gemfile, 'r').read) }