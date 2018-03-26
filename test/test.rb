require "minitest/autorun"
require "fakeweb"
require "json"
require "shopify_api"

class ShopifyAPITest < Minitest::Test

	def setup
		@session = Shopify::Session.new(
			shop: 'shop.myshopify.com',
			key: 'user',
			secret: 'pass'
		)

	end

	def test_get
		FakeWeb.register_uri(:get, "https://user:pass@shop.myshopify.com/admin/products",
			body: '{"products":[]}',
			content_type: "application/json"
		)

		response = @session.get "products"

		assert_equal 200, response.code
	end

	def test_delete
		FakeWeb.register_uri(:delete, "https://user:pass@shop.myshopify.com/admin/products/1234",
			body: '',
			content_type: "application/json"
		)

		response = @session.delete "products/1234"

		assert_equal 200, response.code
	end

end