module UR
  class Product
    class Storage
      attr_reader :ordernumber, :compatible, :storage_type, 
                  :storage_format, :location, :storage_kind
  
      def initialize(data)
        @order_number = data['ordernumber']
        @compatible = data['compatible']
        @storage_type = data['type']
        @storage_format = data['format']
        @location = data['location']
        @storage_kind = data['storage_kind']
      end
    end
  end
end