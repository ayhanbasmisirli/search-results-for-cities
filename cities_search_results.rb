require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'sqlite3'

begin 
  # Setup the database
  db = SQLite3::Database.open "search_results.db"
  db.execute "CREATE TABLE IF NOT EXISTS City(Name TEXT, Num INT)"
  # Get the list of city names
  data = File.read("cities.txt")
  cities = data.split("\n")
  cities.each do |city|
    # Google each name
    link = "https://www.google.com/search?q=" + city.gsub(" ", "+") # gsub replaces
    page = Nokogiri::HTML(open(link))
    # Parse the number of search results as an integer
    num = page.css("div#resultStats").text[/[\d,]+/].delete(',').to_i
    # Store the city name and number into the database
    stm = db.prepare "INSERT INTO City VALUES(?, ?)"
    stm.bind_params city, num
    rs = stm.execute
  end

# Error handling
rescue SQLite3::Exception => e
  puts "Exception occured"
  puts e
  db.rollback

# Closing the database
ensure
  stm.close if stm
  db.close if db
end