require 'bundler/setup'
Bundler.require

require 'sinatra/chassis/helpers'

require 'sinatra/reloader' if development?

require_directory(settings.load_path)

enable :sessions
set :session_secret, 'secret123'

set :public_folder, 'public'
enable :run

DataMapper.finalize