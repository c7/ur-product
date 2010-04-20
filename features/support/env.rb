require 'spec/expectations'

# FakeWeb
require 'fakeweb'

FakeWeb.allow_net_connect = false

faked_urls = [
  'http://metadata.ur.se/products/100001.json', 
  'http://metadata.ur.se/products.json?ur_product_ids=100001,150423'
]

faked_urls.each do |url|
  page = `curl -is #{url}`
  FakeWeb.register_uri(:get, url, :response => page)
  # puts "FAKED: #{url}"
end