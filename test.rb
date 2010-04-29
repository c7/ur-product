require 'rubygems'
require 'lib/ur-product'

results = UR::Product.search({
  :queries => 'samtid',
  :filter => { :search_product_type => 'programtv' },
  :page => 1,
  :per_page => 5,
  :publicstreaming => 'NOW'
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
end