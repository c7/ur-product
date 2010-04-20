Gem::Specification.new do |s|
  s.name          = "ur-product"
  s.version       = "0.1"
  s.date          = "2010-04-20"
  s.summary       = "Retrieve products from the Utbildningsradion Metadata Cache"
  s.description   = "Wraps the Utbildningsradion Metadata Cache API"
  s.has_rdoc      = false
  s.email         = "peter@c7.se"
  s.homepage      = "http://metadata.ur.se/"
  s.authors       = ["Peter Hellberg"]
  s.licenses      = "MIT-LICENSE"
  
  s.files         = [
    "README.markdown",
    "MIT-LICENSE", 
    "lib/ur-product.rb",
    "lib/ur/metadata-cache.rb",
    "lib/ur/product.rb"
  ]
  
  s.rubyforge_project = "ur-product"
  s.add_dependency('json', '>= 1.2.3')
  s.add_dependency('rest-client', '>= 1.4.2')
end
