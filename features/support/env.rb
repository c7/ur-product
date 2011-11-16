# encoding: utf-8

require 'rspec'
require 'rspec/expectations'
World(RSpec::Matchers)

# FakeWeb
require 'fakeweb'

FakeWeb.allow_net_connect = false

faked_urls = [
  'http://metadata.ur.se/products/100001.json',
  'http://metadata.ur.se/products.json?ur_product_ids=100001,150423',
  'http://assets.ur.se/id/100001/images/1.jpg'
]

faked_urls.each do |url|
  page = `curl -is #{url}`
  FakeWeb.register_uri(:get, url, :response => page)
  FakeWeb.register_uri(:head, url, :response => page)
end
