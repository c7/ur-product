# encoding: utf-8

require 'rsolr-ext'
require 'rest-client'
require 'yajl'

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

    def num_found
      (ok?) ? @solr.response['numFound'].to_i : 0
    end

    def self.current_programs(per_page = 10, offset = 0, format = false, agerange = false)
      url = "#{SEARCH_SERVICE_URL}/select?qt=current-products" +
            "&rows=#{per_page}&start=#{offset}" +
            "&publicstreaming=NOW" +
            "&fq=(search_product_type:programtv" +
            "%20OR%20search_product_type:programradio)"

      if ['audio','video'].include? format
        url += "%20AND%20format:#{format}"
      end

      url += agerange_filter(agerange)

      response = RestClient.get(url)
      json = Yajl::Parser.parse(response)

      if (json['response']['docs'].count > 0)
        Product.find(json['response']['docs'].map { |d| d['id'] })
      else
        []
      end
    end

    ##
    # Pagination
    #

    def current_page
      (!@solr.docs.nil?) ? @solr.docs.current_page : 0
    end

    def total_pages
      (!@solr.docs.nil?) ? @solr.docs.total_pages : 0
    end

    def previous_page
      (current_page > 1) ? @solr.docs.previous_page : false
    end

    def next_page
      (current_page < total_pages) ? @solr.docs.next_page : false
    end

  private
    def self.agerange_filter(agerange, prepend = '%20AND%20')
      if ['children', 'youths', 'adults'].include? agerange
        filter = '(typicalagerange:' +
        {
          'children' => ['preschool', 'primary0-3', 'primary4-6'],
          'youths'   => ['primary7-9', 'secondary'],
          'adults'   => ['schoolvux', 'komvuxgrundvux', 'teachereducation',
                         'popularadulteducation', 'folkhighschool', 'university']
        }[agerange].join('%20OR%20typicalagerange:') + ')'

        if prepend
          filter = prepend + filter
        end

      else
        filter = ''
      end

      filter
    end
  end
end
