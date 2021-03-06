# encoding: utf-8

require 'time'
require 'rest-client'

# Module for Utbildningsradion AB (http://ur.se/)
module UR
  # A product can be a tv show, a radio program or even a website
  class Product
    # Setup
    if !defined?(ASSETS_URL)
      ASSETS_URL = 'http://assets.ur.se'
    end

    attr_reader :related_products,
                :ur_product_id, :title, :languages,
                :description, :easy_to_read_description,
                :obsolete_order_id, :status, :production_year,
                :main_title, :remainder_of_title, :producing_company,
                :created_at, :modified_at, :format, :duration, :aspect_ratio,
                :product_type, :product_sub_type, :typical_age_ranges,
                :publication_date, :storages, :distribution_events, :difficulty,
                :sli, :sli_sub, :sab, :sao, :fao, :related_product_ids

    def initialize(data)
      unless !data['status'].nil? && data['status'] == 404
        product_data = data.include?('product') ? data['product'] : data
        relations = data.include?('relations') ? data['relations'] : []
        populate(product_data, relations)

        self.class.define_boolean_methods([
          'distribution_events', 'storages', 'typical_age_ranges', 'languages',
          'duration', 'difficulty', 'producing_company', 'production_year',
          'obsolete_order_id', 'sli', 'sli_sub', 'sab', 'sao', 'fao'
        ])
        self.class.define_relation_boolean_methods([
          'siblings', 'packageseries', 'packageusageseries', 'website',
          'packagedvd', 'packagecd', 'programtv', 'programradio',
          'trailertrailer'
        ])
        def ok?; true; end
      else
        def ok?; false; end
      end
    end

    def self.find(id)
      data = MetadataCache.find(id)

      (data.instance_of?(Array)) ?
        data.map { |d| Product.new(d) } : Product.new(data)
    end

    def self.search(solr_params)
      UR::Search.new(solr_params)
    end

    def self.define_boolean_methods(names)
      names.each do |name|
        define_method("has_#{name}?") do
          instance_variable = instance_variable_get("@#{name}")
          !(instance_variable.nil? || instance_variable.to_s.empty?)
        end
      end
    end

    def self.define_relation_boolean_methods(names)
      names.each do |name|
        define_method("has_#{name}?") do
          related_products = instance_variable_get("@related_products")
          (!related_products.nil? &&
            (!related_products[name].nil? &&
              !related_products[name].to_s.empty?))
        end
      end
    end

    def self.define_relation_accessor(name)
      define_method(name) do
        instance_variable_get("@related_products")[name]
      end
    end

    # Populate the object
    def populate(product_data, relations)
      # Handle the fields
      standard_fields = [
        'id', 'obsoleteorderid', 'status', 'language',
        'title.sv', 'maintitle.sv', 'remainderoftitle.sv',
        'description.sv', 'easytoreaddescription.sv',
        'productionyear', 'producingcompany',
        'created', 'modified', 'pubdate',
        'format', 'duration', 'aspect_ratio',
        'product_type', 'product_sub_type',
        'typicalagerange', 'difficulty',
        'sli', 'sli_sub', 'sab', 'sao', 'fao'
      ]

      field_names = lambda do |name|
        renamed = {
          'id' => 'ur_product_id',
          'maintitle' => 'main_title',
          'remainderoftitle' => 'remainder_of_title',
          'easytoreaddescription' => 'easy_to_read_description',
          'producingcompany' => 'producing_company',
          'created' => 'created_at',
          'modified' => 'modified_at',
          'pubdate' => 'publication_date',
          'obsoleteorderid' => 'obsolete_order_id',
          'typicalagerange' => 'typical_age_ranges',
          'productionyear' => 'production_year',
          'language' => 'languages'
        }
        (renamed.keys.include?(name)) ? renamed[name] : name
      end

      standard_fields.each do |field|
        field,lang = field.split('.')

        if lang.nil?
          value = product_data[field]
        elsif !product_data[field].nil?
          value = product_data[field][lang]
        end

        if ['pubdate', 'created', 'modified'].include? field
          value = Time.parse(value)
        end

        instance_variable_set("@#{field_names.call(field)}", value)
      end

      # Handle the data structures
      [
        ['distributionevent', 'distribution_events', UR::Product::DistributionEvent],
        ['storage', 'storages', UR::Product::Storage],
        ['relation_haspart', 'related_product_ids', UR::Product::RelatedProductId],
      ].each do |name, variable, structure_class|
        data = product_data[name]
        instance_variable_set("@#{variable}", (!data.nil? && data.size > 0) ?
          data.map { |d| structure_class.new d } : [])
      end

      # Handle the relations
      @related_products = {}
      if relations.size > 0
        @has_relations = true
        relations.each do |name, products|
          @related_products[name] = []

          products.each do |related_product_data|
            @related_products[name] << Product.new(related_product_data)
          end

          self.class.define_relation_accessor(name)
        end
      end
    end

    def active_distribution_events
      return @active_distribution_events unless @active_distribution_events.nil?

      @active_distribution_events = {}

      distribution_events.each do |event|
        @active_distribution_events[event.receiving_agent_group] = event if event.active?
      end

      @active_distribution_events
    end

    def available_on_avc?
      !active_distribution_events['avc'].nil?
    end

    def broadcasts
      return @broadcasts unless @broadcasts.nil?
      @broadcasts = []

      distribution_events.each do |event|
        @broadcasts << event if event.event_type == 'broadcast'
      end

      @broadcasts = @broadcasts.sort_by { |broadcast| broadcast.start_date }
      @broadcasts
    end

    def documents
      return @docs unless @docs.nil?
      @docs = []

      [
        'textteacherguide',
        'textstudyguide',
        'textscript',
        'textworksheet',
        'texttasks',
        'texttext'
      ].each do |name|
        @docs << @related_products[name] if !@related_products[name].nil?
      end

      @docs.flatten!
    end

    def has_documents?
      (!documents.nil? && documents.size > 0)
    end

    def humanized_duration
      if matched = duration.match(/^(\d\d):(\d\d):(\d\d)/)
        (full,h,m,s) = matched.to_a
        if h == '00' && m != '00'
          "#{m.to_i} minuter"
        elsif h == '00'
          'Under en minut'
        else
          "#{h.to_i}:#{m}"
        end
      else
        duration
      end
    end

    def full_type
      broadcast_format = (product_type == 'package') ? "-#{format}" : ''
      (product_sub_type.nil?) ? product_type : "#{product_type}#{product_sub_type}#{broadcast_format}"
    end

    def image_url(number = 1, size = '')
      "#{ASSETS_URL}/id/#{ur_product_id}/images/#{number}#{size}.jpg"
    end

    def has_image?(number = 1, size = '')
      return @has_image if !@has_image.nil?

      begin
        url = "#{ASSETS_URL}/id/#{ur_product_id}/images/#{number}#{size}.jpg"
        @has_image = (RestClient.head(url).headers[:x_ur_http_status] == "200")
      rescue RestClient::ResourceNotFound
        @has_image = false
      end

      @has_image
    end

    def has_relations?
      (!@related_products.nil? && @related_products.size > 0)
    end

    def get_storage_location(format)
      storage = storages.map { |s| s if s.storage_format == format }.compact
      storage.empty? ? false : storage.first.location
    end

    def media_id
      @media_id ||= (get_storage_location('genericvideo') ||
                     get_storage_location('genericaudio'))
      @media_id
    end

    def has_media_id?
      (media_id)
    end

    def url
      return @url unless @url.nil?

      if product_type == 'website'
        @url = get_storage_location('url')
      elsif respond_to?(:website) && website.respond_to?(:first)
        if website.first.nil?
          @url = false
        else
          @url = website.first.get_storage_location('url')
        end
      else
        @url = false
      end

      @url
    end

    def has_url?
      (url)
    end

    def short_title
      if !remainder_of_title.nil?
        remainder_of_title
      else
        title
      end
    end
  end
end
