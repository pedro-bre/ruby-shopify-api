# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubygems"
require "shopify_api/version"


Gem::Specification.new do |s|
	s.name        = "shopify_api"
	s.version     = Shopify::VERSION
	s.date        = "2018-03-16"

	s.summary     = "A Ruby wrapper for the Shopify admin REST web services"
	s.description = "This gem provides a wrapper to deal with the Shopify REST API"

	s.authors     = ["Pedro Bre"]
	s.email       = "pedro@optimmerce.net"
	s.files       = Dir["lib/shopify_api.rb", "lib/shopify_api/*.rb"]
	s.homepage    = "https://github.com/pedro-bre/ruby-shopify-api"

	s.add_runtime_dependency "httparty"
	s.add_runtime_dependency "json"
end