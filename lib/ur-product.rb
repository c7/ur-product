# encoding: utf-8

require File.dirname(__FILE__) + '/ur/metadata_cache'
require File.dirname(__FILE__) + '/ur/product'
require File.dirname(__FILE__) + '/ur/product/distribution_event.rb'
require File.dirname(__FILE__) + '/ur/product/related_product_id.rb'
require File.dirname(__FILE__) + '/ur/product/storage.rb'
require File.dirname(__FILE__) + '/ur/search'
require File.dirname(__FILE__) + '/ur/streaming'
require File.dirname(__FILE__) + '/ur/version'

module UR
  class InvalidProductID < Exception
  end

  class InvalidResponse < Exception
  end
end
