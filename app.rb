require 'sidekiq'
require 'sinatra/base'
require_relative 'lib/worker'

Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" }
end

$redis = Redis.new( url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}" )

class App < Sinatra::Application
  # get '/things' do
  #   things = $redis.hvals('things')
  #   status 200
  #   things.to_json
  # end

  # loop do
  #   sleep 10
  #   Worker.perform_async(req['id'])
  # end
  
  post '/' do
    content_type :json
    req = JSON.load(request.body.read.to_s)
    # $redis.hset('jobs', req['id'], req['hash'])
    Worker.perform_async(req['id'])
    # "enqueue #{req['id']}, #{req['thing']}"
    status 202
  end
end