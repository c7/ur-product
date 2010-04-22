# UR::Product

API wrapper for the [Utbildningsradion](http://ur.se) product services.

### Installation

    gem install ur-product

### Related Resources (in Swedish)

  * [Metadata Cache](http://metadata.ur.se)
  * [Search](http://services.ur.se/search)
  
### Example usage

#### Find
    require 'ur-product'
    product = UR::Product.find(100001)

#### Search
    require 'ur-product'
    UR::Product.search({
      :queries => 'samtid',
      :filter => { :search_product_type => 'programtv' },
      :page => 1,
      :per_page => 5,
      :publicstreaming => 'NOW'
    })

### Dependencies

 * [RSolr](http://github.com/mwmitchell/rsolr)
 * [RSolr-ext](http://github.com/mwmitchell/rsolr-ext)
 * [RestClient](http://github.com/archiloque/rest-client)
