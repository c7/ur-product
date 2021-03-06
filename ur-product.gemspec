lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'ur/version'

Gem::Specification.new do |s|
  s.name          = "ur-product"
  s.version       = UR::VERSION::STRING
  s.date          = Time.now.strftime('%Y-%m-%d')
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
    "lib/ur/version.rb",
    "features/product.feature",
    "features/support/env.rb",
    "features/step_definitions/product_steps.rb"
  ]

  s.rubyforge_project = "ur-product"

  s.add_dependency('yajl-ruby', '~> 1.1')
  s.add_dependency('rsolr', '~> 1.0')
  s.add_dependency('rsolr-ext', '~> 1.0')
  s.add_dependency('rest-client', '~> 1.6')

  s.add_development_dependency('cucumber', '~> 1.1')
  s.add_development_dependency('rspec', '~> 2.7')
  s.add_development_dependency('fakeweb', '~> 1.3')
end
