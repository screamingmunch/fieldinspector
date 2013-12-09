class HomeController < ApplicationController
    def index
    # render inline: "hello world"
    @photos = Photo.all || "photos"
    @photo = Photo.new(params[:key])

    if request.method.to_s == 'POST'
      binding.pry_remote
    end

  end
end
