# Module for Utbildningsradion AB (http://ur.se/)
module UR  
  # A product can be a tv show, a radio program or even a website
  class Product
    # Setup
    ASSETS_URL = 'http://assets.ur.se'
    attr_accessor :related_products,
                  :ur_product_id, :title, :language, 
                  :description, :easy_to_read_description,
                  :obsoleteorderid, :status, :productionyear,
                  :maintitle, :remainderoftitle, :producingcompany,
                  :created, :modified, :format, :duration, :aspect_ratio,
                  :product_type, :product_sub_type, :typical_age_range, 
                  :pubdate
    
    def initialize(data)
      product_data = data.include?('product') ? data['product'] : data
      relations = data.include?('relations') ? data['relations'] : []
      populate(product_data, relations)
      
      self.class.define_boolean_methods(['siblings'])
    end
    
    def self.find(id)
      data = MetadataCache.find(id)
      
      (data.instance_of?(Array)) ? 
        data.map { |d| Product.new(d) } : Product.new(data)
    end
    
    def self.define_boolean_methods(names)
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
        'typical_age_range'
      ]
      
      field_names = lambda do |name|
        renamed = { 
          'id' => 'ur_product_id', 
          'easytoreaddescription' => 'easy_to_read_description',
          'typicalagerange' => 'typical_age_range'
        }
        (renamed.include?(name)) ? renamed[name] : name
      end
      
      standard_fields.each do |field|
        field,lang = field.split('.')
        
        if lang.nil?
          value = product_data[field]
        elsif !product_data[field].nil?
          value = product_data[field][lang]
        end
        
        self.send("#{field_names.call(field)}=", value)
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

    def has_image?
      return @has_image if !@has_image.nil?
      
      begin
        url = "#{ASSETS_URL}/id/#{ur_product_id}/images/1.jpg"
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