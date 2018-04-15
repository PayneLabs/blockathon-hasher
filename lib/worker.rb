require 'sidekiq'
require 'digest'
require 'net/http'
require 'uri'
require 'json'

Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}", timeout: 0 }
end

class Worker
  include Sidekiq::Worker
  def perform(id)
    # ipfs_uri = $redis.hget('job', id) #Assigns a string to job variable that is the IPFS hash of the document location.
    # uri = URI.parse("http://encoder:4500") #TODO: Add in environmental variable management for encoder URI

    $redis.subscribe('jobs') do |on|
  	  on.message do |msg|
        data = JSON.parse(msg)
        # puts "##{channel} - [#{data['user']}]: #{data['msg']}"
        header = {'Content-Type': 'text/json'}

        # Get SHA256 Hash of a file
		hashed_ipfs_uri = Digest::SHA256.hexdigest msg.ipfs_uri #Hash the URI using SHA256

		hashed_data = {document_id: msg.id, document_hash: hashed_ipfs_uri}


		# Create the HTTP objects
		http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Post.new(uri.request_uri, header)
		request.body = hashed_data.to_json


		# Send the request
		response = http.request(request) # TODO: Add in try/catch and error handling in case something happens here
  	  end
	end

  end
end