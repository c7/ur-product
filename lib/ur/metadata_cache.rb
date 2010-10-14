require 'uri'
require 'yajl'
require 'yajl/http_stream'

# Module for Utbildningsradion AB (http://ur.se/)
module UR
  # Responsible for retrieving metadata and 
  # populating one or more UR::Product objects
  class MetadataCache
    # Setup
    if !defined?(METADATA_PRODUCT_URL)
      METADATA_PRODUCT_URL = 'http://metadata.ur.se/products'
    end
    
    # Retrieve one or more products
    def self.find(id)
      if id.instance_of?(Array)
        valid_ids = []
        
        id.each do |id|
          if id.to_s.match(/^1\d{5}$/)
            valid_ids << id 
          else
            raise UR::InvalidProductID
          end
        end
        
        url = METADATA_PRODUCT_URL + ".json?ur_product_ids=#{valid_ids.join(',')}"
      else
        raise UR::InvalidProductID if !id.to_s.match(/^1\d{5}$/)
        url = METADATA_PRODUCT_URL + "/#{id}.json"
      end
      
      begin
        # Get the JSON response from the Metadata Cache
        response = Yajl::HttpStream.get(URI.parse(url))      
      rescue Yajl::HttpStream::HttpError
        # Raise an invalid response exception if there was 
        # a problem with the HTTP request
        raise UR::InvalidResponse
      end
      
      # Return the response as a parsed JSON object
      response
    end
  end
end