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
      # Prepare the facets
      @products = []
      @facets = {}
      @solr   = nil
      
      begin 
        solr = RSolr.connect :url => SEARCH_SERVICE_URL
        response = solr.find solr_params
        
        # Populate the products from the Metadata Cache
        @products = (response.ok? && response.docs.size > 0) ?
          Product.find(response.docs.map { |d| d.id }) : []
        
        # Expose the Solr response
        @solr = response
        @solr.facets.map { |f| @facets[f.name] = f.items } if @solr.facets.size > 0
      rescue RSolr::RequestError => e
      end
    end
    
    def ok?
      (!@solr.nil? && @solr && @solr.ok?)
    end
    
    def per_page
      (ok?) ? @solr.params['rows'].to_i : 0
    end
    
    def total_pages
      (ok? && !@solr.docs.nil?) ? @solr.docs.total_pages : 0
    end
    
    def num_found
      (ok?) ? @solr.response['numFound'].to_i : 0
    end
    
    def previous_page
      (ok? && !@solr.docs.nil?) ? @solr.docs.previous_page : 0
    end
    
    def next_page
      (ok? && !@solr.docs.nil?) ? @solr.docs.next_page : 0
    end
  end
end