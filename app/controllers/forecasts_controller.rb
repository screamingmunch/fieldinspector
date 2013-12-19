class ForecastsController < ApplicationController
  def index
    @latitude = Location.find(params[:location_id]).latitude
    @longitude = Location.find(params[:location_id]).longitude
    url = "http://forecast.weather.gov/MapClick.php?lat=#{@latitude}&lon=#{@longitude}"
    @forecast = Hash.new
    i=0
    data = Nokogiri::HTML(open(url).read)
    data.css("ul.point-forecast-7-day li").each do |day|
      time = day.at_css("span").text.tr(' ', '_')
      weather = day.xpath('text()').to_s.strip
      # @forecast[time] = weather
      # Table.create("day"=> forecast[1])
      # Forecast.create(:forcast_day => time, :weather => weather)
      chance_of_rain = weather.scan(/100%/) || weather.scan(/\d\d%/)
      unless chance_of_rain.empty?
        if chance_of_rain == ["100%"]
          chance = 100
        else
          chance = chance_of_rain[0].scan(/\d\d/).join('').to_i
        end
      end

      if !chance_of_rain.empty? && chance >= 50
        inspection = true
      else
        inspection = false
      end
      @forecast[i] = {:forecast_day => time, :weather => weather, :inspection => inspection}
      i += 1
    end
    render json: @forecast.to_json

  end

  def forecast_json
    if params[:location_id]
      @latitude = Location.find(params[:location_id]).latitude
      @longitude = Location.find(params[:location_id]).longitude
    else
      @latitude = params[:lat]
      @longitude = params[:lng]
    end

    url = "http://forecast.weather.gov/MapClick.php?lat=#{@latitude}&lon=#{@longitude}"
    @forecast = Hash.new
    i=0
    data = Nokogiri::HTML(open(url).read)
    data.css("ul.point-forecast-7-day li").each do |day|
      time = day.at_css("span").text.tr(' ', '_')
      weather = day.xpath('text()').to_s.strip
      # @forecast[time] = weather
      # Table.create("day"=> forecast[1])
      # Forecast.create(:forcast_day => time, :weather => weather)
      chance_of_rain = weather.scan(/100%/) || weather.scan(/\d\d%/)
      unless chance_of_rain.empty?
        if chance_of_rain == ["100%"]
          chance = 100
        else
          chance = chance_of_rain[0].scan(/\d\d/).join('').to_i
        end
      end

      if !chance_of_rain.empty? && chance >= 50
        inspection = true
      else
        inspection = false
      end
      @forecast[i] = {:forecast_day => time, :weather => weather, :inspection => inspection}
      i += 1
    end
    render json: @forecast.to_json

  end

end
