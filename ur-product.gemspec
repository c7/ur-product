Gem::Specification.new do |s|
  s.name          = "ur-product"
  s.version       = "0.9.4"
  s.date          = "2010-06-21"
  s.summary       = "API wrapper for the Utbildningsradion product services"
  s.description   = "Enables searching and fetching of Utbildningsradion products"
  s.has_rdoc      = false
  s.email         = "peter@c7.se"
  s.homepage      = "http://github.com/c7/ur-product"
  s.authors       = ["Peter Hellberg"]
  s.licenses      = "MIT-LICENSE"
  
  s.files         = [
    "README.markdown",
    "Rakefile",
    "MIT-LICENSE",
    "lib/ur-product.rb",
    "lib/ur/metadata_cache.rb",
    "lib/ur/product.rb",
    "lib/ur/product/distribution_event.rb",
    "lib/ur/product/related_product_id.rb",
    "lib/ur/product/storage.rb",
    "lib/ur/search.rb",
    "lib/ur/streaming.rb",
    "features/product.feature",
    "features/support/env.rb",
    "features/step_definitions/product_steps.rb"
  ]
  
  s.rubyforge_project = "ur-product"
  
  s.add_dependency('yajl-ruby', '>= 0.7.6')
  s.add_dependency('rsolr', '>= 0.12.1')
  s.add_dependency('rsolr-ext', '>= 0.12.0')
  s.add_dependency('rest-client', '>= 1.4.2')
end
