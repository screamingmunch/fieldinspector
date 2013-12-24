class ReportsController < ApplicationController
  def index
    @location = Location.find(params[:location_id])
  end
  def new
    @location = Location.find(params[:location_id])
    @report = Report.new
    # @photo = Photo.create(params[:photo])
    url = "http://forecast.weather.gov/MapClick.php?lat=#{@location.latitude}&lon=#{@location.longitude}"
    @forecast = Hash.new
    i=0
    data = Nokogiri::HTML(open(url).read)
    @current_temp = data.css("p.myforecast-current-lrg").xpath('text()').to_s
    data.css("ul.point-forecast-7-day li").each do |day|
      time = day.at_css("span").text.tr(' ', '_')
      weather = day.xpath('text()').to_s.strip
      # @forecast[time] = weather
      # Table.create("day"=> forecast[1])
      # Forecast.create(:forcast_day => time, :weather => weather)
      if weather.scan(/100%/).empty?
        if !weather.scan(/\d\d%/).empty?
          chance_of_rain = weather.scan(/\d\d%/)
          @chance = chance_of_rain.join('').to_i
        else
          chance_of_rain = []
          @chance = 0
        end
      else
        chance_of_rain = weather.scan(/100%/)
        @chance = 100
      end
        if !chance_of_rain.empty? && chance >= 50
          inspection = true
        else
          inspection = false
        end
        @forecast[i] = {:forecast_day => time, :weather => weather, :inspection => inspection}
        i += 1
    end
  end

  def create
    @report = Report.create(params[:report])
    redirect_to location_reports_path
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
