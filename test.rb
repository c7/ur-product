require 'rubygems'
require 'lib/ur-product'

results = UR::Product.search({
  :queries => 'lärarhandledning',
  :filters => { :search_product_type => 'packageseries' },
  :page => 1,
  :per_page => 1
})

if results.ok?
  puts "Sökning: #{results.solr.params.inspect}\n\n"
  
  results.products.map { |p| puts p.title }
  
  puts "\nFöregående sida: #{results.previous_page}"
  puts "Nästa sida: #{results.next_page}"
  puts "\nAntal träffar: #{results.num_found}\n"
  
  results.facets.each_pair do |name, items|
    puts "\nFacett: #{name}"
    items.each do |item|
      puts " - #{item.value} => #{item.hits}"
    end
  end
  
  p = results.products.first
  puts "\n\nFörsta produkten: #{p.title} (#{p.ur_product_id})"
  puts "  -> Distribution: #{p.distribution_events.map { |e| e.platform }.join(', ')}" if p.has_distribution_events?
  puts "  -> Lagring: #{p.storages.map { |s| s.storage_format }.join(', ')}" if p.has_storages?
  puts "  -> Andra stora bilden: #{p.image_url(2, '_l')}" if p.has_image?(2, '_l')


  p = UR::Product.find(106485)
  if p.has_documents?
    puts p.documents.first.storages.first.location
  end
  
  p = UR::Product.find(143664)
  puts p.url
  
  
  p = UR::Product.find(140502)
  puts p.url
  puts p.related_product_ids
  
end
