require 'yajl/http_stream'

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
      @data[product.ur_product_id.to_s]
    end
    
    def self.search(ids)
      return [] if ids.empty?
      url = STREAMING_URL + '.json?ur_product_ids=' + ids.join(',')
      Streaming.new(Yajl::HttpStream.get(url))
    end
  end
end