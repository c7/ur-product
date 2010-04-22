require File.dirname(__FILE__) + '/ur/metadata_cache'
require File.dirname(__FILE__) + '/ur/product'
require File.dirname(__FILE__) + '/ur/search'

module UR
  class InvalidProductID < Exception
  end
  
  class InvalidResponse < Exception
  end
end