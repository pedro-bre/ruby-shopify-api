# ruby-shopify-api

Installation
------------

```
gem "shopify_api", git: 'https://github.com/pedro-bre/ruby-shopify-api.git'
```

Getting started
---------------

For a private app:

```ruby
session = Shopify::Session.new(
  shop: 'your-shop.myshopify.com',
  key: 'PRIVATE_API_KEY',
  secret: 'PRIVATE:_API_SECRET'
)
```

For a public app, we need to follow the OAuth flow first:\
([https://help.shopify.com/api/getting-started/authentication/oauth](https://help.shopify.com/api/getting-started/authentication/oauth))

```ruby
# get authorization url
oauth = Shopify::Auth.new(
  :shop => 'your-shop.myshopify.com',
  :api_key => 'APP_KEY', 
  :api_secret => 'APP_SECRET', 
  :scope => 'SCOPE', 
  :redirect_uri => 'REDIRECT_URI',
  :nonce => '12345'
)

# redirect to permission url
permission_url = oauth.generate_permission_url

# after authorization, exchange received params with the access token
access_token = oauth.generate_token(params)

# we can now start a new API session
session = Shopify::Session.new(
  shop: 'your-shop.myshopify.com',
  access_token: access_token
)
```
and then:

```ruby
# find all products on first page
products = session.get('products', {page: 1})
# find a single product
products = session.get('products/18273647')
# delete product
products = session.delete('products/18273647')
# update product
products = session.put('products/18273647', {product: {title: 'New product title'}})
# create product
products = session.post('products', {product: {title: 'New product title'}})
```