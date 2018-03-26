module Shopify
	class Auth

		OAUTH_ENDPOINT = '/admin/oauth/authorize'
		TOKEN_ENDPOINT = '/admin/oauth/access_token'

		OAUTH_ARGS = [:shop, :api_key, :api_secret, :scope, :redirect_uri, :nonce].freeze

		attr_accessor(*OAUTH_ARGS)

		def initialize(options = {})
			options.each do |key, value|
				self.send("#{key}=", value) if self.respond_to?("#{key}=")
			end
		end

		def generate_permission_url
			# oauth permission redirect
			get_authorize_url
		end

		def generate_token(query_params)
			# perform security measures
			# cross check nonce with state			
			raise 'State Error' if query_params[:state] != nonce

			# cross check generated hmac with received
			hmac = generate_hmac(query_params, api_secret)
			raise 'HMAC Error' if hmac != query_params[:hmac]

			# check if hostname is valid
			hostname = query_params[:shop]		
			raise 'Invalid Hostname' unless hostname.include?('.myshopify.com') || hostname =~ /[^a-zA-Z0-9]/

			# get permanent access token
			response = fetch_access_token(query_params[:code])
			return response['access_token'], response['scope']
		end

		protected

		def generate_hmac(query_params, secret)
			map = query_params.except(:hmac, :action, :controller).sort.to_h
			digest = OpenSSL::Digest.new('sha256')
			message = URI.encode_www_form(map)
			OpenSSL::HMAC.hexdigest(digest, secret, message)
		end

		def fetch_access_token(code)
			host = shop
			full_path = TOKEN_ENDPOINT
			uri = URI::HTTPS.build(
				host: host, 
				path: full_path
			)
			body = {
				client_id: api_key,
				client_secret: api_secret,
				code: code
			}
			options = {
				body: body.to_json,
				headers: {
					"Content-Type" => "application/json"
				}
			}
			
			HTTParty.send :post, uri.to_s, options
		end

		def get_authorize_url
			params = {
				client_id: api_key,
				scope: scope,
				redirect_uri: redirect_uri,
				state: nonce
			}
			
			URI::HTTPS.build(host: shop, path: OAUTH_ENDPOINT, query: URI.encode_www_form(params)).to_s
		end

	end
end