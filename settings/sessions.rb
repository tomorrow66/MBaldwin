# Session settings:
#
# Be sure to set your own session secret.

enable :sessions

set :session_secret, 'your_secret_here'

use Rack::Flash