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
  'http://assets.ur.se/id/100001/images/1.jpg',
  'http://services.ur.se/search/select?qt=current-products&rows=10&start=0&publicstreaming=NOW&fq=(search_product_type:programtv%20OR%20search_product_type:programradio)',
  'http://metadata.ur.se/products.json?ur_product_ids=165422,166790,165412,165070,166257,165368,165367,167372,167373,165146,165008,166807,165463,164971,164976,165152,164975,164974,164973,164972'
]

faked_urls.each do |url|
  page = `curl -is #{url}`
  FakeWeb.register_uri(:get, url, :response => page)
  FakeWeb.register_uri(:head, url, :response => page)
end
