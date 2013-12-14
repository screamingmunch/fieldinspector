require 'nokogiri'
require 'open-uri'

# url = "http://forecast.weather.gov/MapClick.php?lat=37.72254909999999&lon=-122.4410618&site=all&smap=1&searchresult=San%20Francisco%2C%20CA%2094112%2C%20USA#.UqoHEGRDvE0"
# url ="weather_test.html"
# data = Nokogiri::HTML(open(url).read)
# p data
# data.css("ul.point-forecast-7-day li").each do |day|
#   puts day.at_css("span").text
#   puts day.xpath('text()').to_s.strip
#   puts "---"
# end


latitude = 37.72254909999999
longitude = -122.4410618
url ="http://forecast.weather.gov/MapClick.php?lat=#{latitude}&lon=#{longitude}"
data = Nokogiri::HTML(open(url).read)
# # p data
forecast = Hash.new
data.css("ul.point-forecast-7-day li").each do |day|
  time = day.at_css("span").text
  weather = day.xpath('text()').to_s.strip
  forecast[time] = weather
end

puts forecast


