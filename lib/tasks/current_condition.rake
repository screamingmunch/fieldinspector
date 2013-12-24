desc "Fetch current weather conditions from NOAA"
task :fetch_conditions => :environment do
  require 'nokogiri'
  require 'open-uri'
  # require 'typheous'

  Location.all.each do |location|
    latitude = location.latitude
    longitude = location.longitude
    puts latitude
    puts longitude
    url = "http://forecast.weather.gov/MapClick.php?lat=#{latitude}&lon=#{longitude}"
    puts url
    forecast = Hash.new
    i=0
    data = Nokogiri::HTML(open(url).read)
    # puts data.to_s
    data.css("ul.point-forecast-7-day li").each do |day|
      time = day.at_css("span").text
      weather = day.xpath('text()').to_s.strip
      if weather.scan(/100%/).empty?
        if !weather.scan(/\d\d%/).empty?
          chance_of_rain = weather.scan(/\d\d%/)
          chance = chance_of_rain.join('').to_i
        else
          chance_of_rain = []
          chance = 0
        end
      else
        chance_of_rain = weather.scan(/100%/)
        chance = 100
      end
        if !chance_of_rain.empty? && chance >= 50
          inspection = true
        else
          inspection = false
        end
        @forecast[i] = {:forecast_day => time, :weather => weather, :inspection => inspection}
        i += 1
    end
    puts forecast
    #right now the rake task just outputs forecast in console..
    #need to write a function that triggers action mailer when rake task returns inspection of true
  end
end


# `rake fetch_conditions` in terminal to run rake task


