Gem::Specification.new do |s|
  s.name          = "ur-product"
  s.version       = "0.1"
  s.date          = "2010-04-22"
  s.summary       = "Utbildningsradion product search and metadata retrieval"
  s.description   = "Wraps the two services http://metadata.ur.se/ and" + 
                    " http://services.ur.se/search/"
  s.has_rdoc      = false
  s.email         = "peter@c7.se"
  s.homepage      = "http://metadata.ur.se/"
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
  s.add_dependency('rest-client', '>= 1.4.2')
end
