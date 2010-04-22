require 'rubygems'
require 'lib/ur-product'

search = UR::Search.search({
  :queries => 'istiden',
  :filter => { :search_product_type => 'programtv' },
  :page => 1,
  :per_page => 5
})

if search.ok?
  puts "Sökning: #{search.solr.params.inspect}\n\n"
  
  search.products.map { |p| puts p.title }
  
  puts "\nFöregående sida: #{search.previous_page}"
  puts "Nästa sida: #{search.next_page}"
  puts "\nAntal träffar: #{search.numFound}\n"
  
  search.facets.each_pair do |name, items|
    puts "\nFacett: #{name}"
    items.each do |item|
      puts " - #{item.value} => #{item.hits}"
    end
  end  
end