class ReportsController < ApplicationController
  def index
    @location = Location.find(params[:location_id])
    @reports = Report.all
  end
  def new
    @location = Location.find(params[:location_id])
    @report = Report.new
    @report.location_id = @location.id
    @report.user_id = current_user.id
  end

  def create
    @location = Location.find(params[:location_id])
    @report = Report.new
    @report.location_id = @location.id
    @report.user_id = current_user.id
    @report.report_date = Date.today.to_s
    @report.save
    redirect_to location_report_path(@location.id, @report.id)
  end

  def show
    @location = Location.find(params[:location_id])
    @report = Report.find(params[:id])
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

  def edit
  end

  def update
    @location = Location.find(params[:location_id])
    @report = Report.find(params[:id])
    @report.update_attributes(params[:report])
    # binding.pry
    @report.save
    redirect_to location_report_path(@location.id, @report.id)
  end

  def destroy
  end
end
