class HomeController < ApplicationController
    def index
    # render inline: "hello world"

    # if request.method.to_s == 'POST'
    #   binding.pry_remote
    # end
    @photos = Photo.all

  end


end
