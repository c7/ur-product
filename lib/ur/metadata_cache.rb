require 'json'
require 'restclient'

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
      
      # Get the JSON response from the Metadata Cache
      response = RestClient.get(url)
      
      # Make sure that we got a valid response
      raise UR::InvalidResponse if response.code != 200
      
      # Return the response as a parsed JSON object
      JSON.parse(response.body)
    end
  end
end