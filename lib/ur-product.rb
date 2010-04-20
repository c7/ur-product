require File.dirname(__FILE__) + '/ur/metadata-cache'
require File.dirname(__FILE__) + '/ur/product'

module UR
  class InvalidProductID < Exception
  end
  
  class InvalidResponse < Exception
  end
end