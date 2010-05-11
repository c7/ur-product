module UR
  class Product
    class RelatedProductId
      attr_reader :ur_product_id
      def initialize(ur_product_id)
        @ur_product_id = ur_product_id
      end
      
      def to_s
        @ur_product_id.to_s
      end
    end
  end
end