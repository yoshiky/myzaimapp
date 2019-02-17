require 'sinatra'
require 'sinatra/reloader'
require 'oauth'
require 'json'
require 'uri'
require 'active_support'
require 'active_support/core_ext'
require 'dotenv'
#require 'logger'

set :bind, '0.0.0.0'
#set :port, 8079

CONSUMER_KEY=ENV["CONSUMER_KEY"]
CONSUMER_SECRET=ENV["CONSUMER_SECRET"]
ACCESS_TOKEN=ENV["ACCESS_TOKEN"]
ACCESS_TOKEN_SECRET=ENV["ACCESS_TOKEN_SECRET"]

#logger = Logger.new('sinatra.log')

before do
  headers 'Access-Control-Allow-Origin' => '*'
  headers 'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept'
  halt 400, "[ERROR] No parameters..." if params.empty?
end

get '/' do
  'hellloxaxx!!!'
end

get '/zaim' do
  consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET,
                                 site: 'https://api.zaim.net',
                                 request_token_path: '/v2/auth/request',
                                 authorize_url: 'https://auth.zaim.net/users/auth',
                                 access_token_path: '/v2/auth/access')
  at = OAuth::AccessToken.new(consumer, ACCESS_TOKEN, ACCESS_TOKEN_SECRET)
  puts "ACCESS_TOKEN: #{at.inspect}"

  uri = URI('https://api.zaim.net/v2/home/money')
  uri.query = params.to_param
  verify = at.get(uri.to_s)
  verify.body
end

get '/zaim/creditcard' do
  consumer = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET,
                                 site: 'https://api.zaim.net',
                                 request_token_path: '/v2/auth/request',
                                 authorize_url: 'https://auth.zaim.net/users/auth',
                                 access_token_path: '/v2/auth/access')
  at = OAuth::AccessToken.new(consumer, ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

  uri = URI('https://api.zaim.net/v2/home/money')
  uri.query = params.to_param
  verify = at.get(uri.to_s)
  money_list = JSON.parse(verify.body)["money"]
  money_list.select{|m| m["from_account_id"] == 4}.to_json unless money_list.nil?
end
