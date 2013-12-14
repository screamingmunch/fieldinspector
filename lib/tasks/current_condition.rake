desc "Fetch current weather conditions from NOAA"
task :fetch_conditions => :environment do
  require 'nokogiri'
  require 'open-uri'
  # require 'typheous'

  Condition.find_all_by_location(nil).each do |condition|
    # file = '/location/json'
    latitude = Location.last.latitude
    longitude = Location.last.longitude
    url = "http://forecast.weather.gov/MapClick.php?lat=#{@latitude}&lon=#{@longitude}&unit=0&lg=english&FcstType=dwml"
    forecast = Hash.new
    data = Nokogiri::HTML(open(url).read)
    data.css("ul.point-forecast-7-day li").each do |day|
      time = day.at_css("span").text
      weather = day.xpath('text()').to_s.strip
      # @forecast[time] = weather
      # Table.create("day"=> forecast[1])
      Forecast.create(:forcast_day => time, :weather => weather)
    end
  end
end
