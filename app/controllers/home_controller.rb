class HomeController < ApplicationController
  
  # Public: This gets all the POI's and users for the index, home page, to use. It also creates
  # a hash that has all the information about each of the POI's to show on the map.
  #
  def index
    @poi = Poi.all
    @users = User.all
    @hash = Gmaps4rails.build_markers(@poi) do |poi, marker|
      next if poi.latitude.nil? || poi.longitude.nil?
      the_user = User.find_by(poi.user_id)
      marker.json({:lat => poi.latitude, :lng => poi.longitude, :infowindow => "Title: #{poi.title}<br>Artist: #{the_user.name}<br><a data-no-turbolink='true' href='#{poi_url(poi.id)}' >More Information</a>", :id => poi.id })
    end
  end
  
  # Public: This gets all the POI's for the all_images view to use.
  #
  def all_images
    @poi = Poi.all
  end
  
  # Public: This gets all the POI's and users for the all_managers view to use. 
  #
  def all_managers
    @users = User.all
    @poi = Poi.all
  end
  
end
