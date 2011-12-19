# encoding: utf-8

require 'rest-client'
require 'yajl'

# Module for Utbildningsradion AB (http://ur.se/)
module UR
  # Streaming information for mp4/mp3 files
  class Streaming
    # Setup
    if !defined?(STREAMING_URL)
      STREAMING_URL = 'http://metadata.ur.se/streaming'
    end

    def initialize(data)
      @data = data
    end

    def [](product)
      if product.respond_to? :ur_product_id
        @data[product.ur_product_id.to_s]
      else
        @data[product.to_s]
      end
    end

    def self.search(ids)
      return [] if ids.empty?
      url = STREAMING_URL + '.json?ur_product_ids=' + ids.join(',')
      Streaming.new(Yajl::Parser.parse(RestClient.get(url)))
    end
  end
end
