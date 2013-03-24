require 'rubygems'
require 'nokogiri'
require 'open-uri'

# Write a new file
File.open('cities.txt', 'w') do |f|
  # Visit each webpage
  ["1", "151", "301", "451"].each do |url|
    page = Nokogiri::HTML(open("http://www.citymayors.com/statistics/largest-cities-mayors-#{url}.html"))
    # On each page, get the list of city names
    cities = page.css('table table tr td:nth-child(2) font')
    # Clean up each name and add it to the file on a new line
    cities.each do |city|
      city = city.text[/\w[\w\s]*/].downcase # regex and make lowercase
      f.write(city + "\n") if !city.nil? && city != "city" # "city" comes from the header
    end
  end
end