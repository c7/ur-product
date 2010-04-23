Gem::Specification.new do |s|
  s.name          = "ur-product"
  s.version       = "0.2"
  s.date          = "2010-04-23"
  s.summary       = "API wrapper for the Utbildningsradion product services"
  s.description   = "Enables searching and fetching of Utbildningsradion products"
  s.has_rdoc      = false
  s.email         = "peter@c7.se"
  s.homepage      = "http://github.com/c7/ur-product"
  s.authors       = ["Peter Hellberg"]
  s.licenses      = "MIT-LICENSE"
  
  s.files         = [
    "README.markdown",
    "MIT-LICENSE", 
    "lib/ur-product.rb",
    "lib/ur/metadata_cache.rb",
    "lib/ur/product.rb",
    "lib/ur/search.rb"
  ]
  
  s.rubyforge_project = "ur-product"
  
  s.add_dependency('json', '>= 1.2.3')
  s.add_dependency('rsolr', '>= 0.12.1')
  s.add_dependency('rsolr-ext', '>= 0.12.0')
  s.add_dependency('rest-client', '>= 1.4.2')
end
