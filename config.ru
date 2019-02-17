require './app'
Dotenv.load
STDOUT.sync = true
run Sinatra::Application

