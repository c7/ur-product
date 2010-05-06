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
                :publication_date, :storages, :distribution_events
    
    def initialize(data)
      product_data = data.include?('product') ? data['product'] : data
      relations = data.include?('relations') ? data['relations'] : []
      populate(product_data, relations)
      
      self.class.define_boolean_methods([
        'distribution_events', 'storages', 'typical_age_ranges', 'languages',
        'duration', 'difficulty', 'producing_company', 'obsolete_order_id'
      ])
      self.class.define_relation_boolean_methods(['siblings'])
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
          !(instance_variable.nil? || instance_variable.empty?)
        end
      end
    end
    
    def self.define_relation_boolean_methods(names)
      names.each do |name|
        define_method("has_#{name}?") do
          related_products = instance_variable_get("@related_products")
          (!related_products.nil? && !related_products[name].nil?)
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
        'typicalagerange'
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
        ['distributionevent', 'distribution_events', DistributionEvent],
        ['storage', 'storages', Storage]
      ].each do |name, variable, structure_class|
        data = product_data[name]
        instance_variable_set("@#{variable}", (!data.nil? && data.size > 0) ? 
          data.map { |d| structure_class.new d } : [])
      end
  
      # Handle the relations
      if relations.size > 0
        @related_products = {}
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
    
    def humanized_duration
      if matched = duration.match(/^(\d\d):(\d\d):(\d\d)/)
        (full,h,m,s) = matched.to_a
        if h == '00'
          "#{m} minuter"
        elsif h == '00' && m == '00'
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
  end
end