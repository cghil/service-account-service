require "sinatra"

require 'dotenv'
Dotenv.load

require "json"
require "boxr"
require "pry"
require 'sinatra/cross_origin'

configure do
  enable :cross_origin
end

class ServerSide
	def self.enterprise_token
		begin
			token_info = Boxr::get_enterprise_token(private_key: ENV['JWT_PRIVATE_KEY'], private_key_password: ENV['JWT_PRIVATE_KEY_PASSWORD'], public_key_id: ENV['JWT_PUBLIC_KEY_ID'], enterprise_id: ENV['BOX_ENTERPRISE_ID'], client_id: ENV['BOX_CLIENT_ID'], client_secret: ENV['BOX_CLIENT_SECRET'])
			enterprise_access_token = token_info.access_token
			admin_client = Boxr::Client.new(enterprise_access_token)
			return admin_client
		rescue Boxr::BoxrError => e
			puts e
		end
	end
	def self.security_check(params)
		token = params[:token]
		if token == ENV['SECURITY']

		end
	end
end

get '/api/service-acount/' do
	response = ServerSide.enterprise_token
	if response.access_token
		access_token = response.access_token
		status 200
		return {access_token: access_token}.to_json
	else
		status 400
	end
end