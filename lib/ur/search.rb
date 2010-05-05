require 'rsolr-ext'

# Module for Utbildningsradion AB (http://ur.se/)
module UR  
  # Search for products and populate from the metadata cache
  class Search
    # Setup
    if !defined?(SEARCH_SERVICE_URL)
      SEARCH_SERVICE_URL = 'http://services.ur.se/search'
    end
    
    attr_reader :products, :solr, :facets
    
    def initialize(solr_params)
      solr = RSolr.connect :url => SEARCH_SERVICE_URL
      response = solr.find solr_params
      
      # Populate the products from the Metadata Cache
      @products = (response.ok? && response.docs.size > 0) ?
        Product.find(response.docs.map { |d| d.id }) : []
      
      # Expose the Solr response
      @solr = response
      
      # Prepare the facets
      @facets = {}
      @solr.facets.map { |f| @facets[f.name] = f.items } if @solr.facets.size > 0
    end
    
    def num_found
      @solr.response['numFound'].to_i
    end
    
    def ok?
      @solr.ok?
    end
    
    def previous_page
      @solr.docs.previous_page
    end
    
    def next_page
      @solr.docs.next_page
    end
  end
end