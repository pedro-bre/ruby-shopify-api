module Shopify
	class Session

		API_ARGS = [:shop, :access_token, :key, :secret].freeze

		attr_accessor(*API_ARGS)
		
		def initialize(options = {})
			options.each do |key, value|
				self.send("#{key}=", value) if self.respond_to?("#{key}=")
			end
		end

		def get(endpoint, query=nil)
			request(:get, add_query_params(endpoint, query))
		end

		def post(endpoint, query=nil, body)
			request(:post, add_query_params(endpoint, query), body)
		end

		def put(endpoint, query=nil, body)
			request(:put, add_query_params(endpoint, query), body)
		end

		def delete(endpoint, query=nil)
			request(:delete, add_query_params(endpoint, query))
		end

		protected

		def add_query_params(endpoint, query)
			return endpoint if query.nil? || query.empty?
			endpoint += "?" unless endpoint.include? "?"
			endpoint += "&" unless endpoint.end_with? "?"

			"#{endpoint}#{URI.encode_www_form(query)}"
		end

		def get_full_url(endpoint)
			endpoint[0] = '' if endpoint.start_with?('/')

			"https://#{shop}/admin/#{endpoint}"
		end

		def request(method, endpoint, body = {})
			url = get_full_url(endpoint)
			options = {
				format: :json,
				headers: {
					"User-Agent" => "Shopify API Ruby Wrapper/#{Shopify::VERSION}",
					"Accept" => "application/json"
				}
			}

			unless body.empty?
				options[:headers]["Content-Type"] = "application/json;charset=utf-8"
				options.merge!(body: body.to_json)
			end

			if access_token # set access token header if public app
				options[:headers]['X-Shopify-Access-Token'] = access_token
			else # set basic auth if private app
				options.merge!(basic_auth: {
					username: key,
					password: secret
				})
			end

			HTTParty.send(method, url, options)
		end

	end
end