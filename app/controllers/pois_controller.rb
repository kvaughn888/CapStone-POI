require 'fileutils'

class PoisController < ApplicationController
  before_action :set_poi, only: [:show, :edit, :update, :destroy, :show_images]

  
  # Public: This gets all the POI's and users for the index view to use. It also creates
  # a hash that has all the information about each of the POI's to show on the map.
  #
  def index
    @poi = Poi.all
    @users = User.all
    @hash = Gmaps4rails.build_markers(@poi) do |poi, marker|
      next if poi.latitude.nil? || poi.longitude.nil?
      marker.lat poi.latitude
      marker.lng poi.longitude
      marker.title poi.title
    end
  end

  # Public: This gets the POI by the given id from the url. It also creates
  # a hash to only has the POI's that the current_users created.
  #
  def show_users_pois
    @poi = Poi.where("user_id == #{current_user.id}")
    @hash = Gmaps4rails.build_markers(@poi) do |poi, marker|
      next if poi.latitude.nil? || poi.longitude.nil?
      marker.lat poi.latitude
      marker.lng poi.longitude
      marker.title poi.title
    end
  end

  # Public: This gets all the users for the show view to use.
  #
  def show
    @users = User.all
  end

  # Public: This gets the POI given the id from the url to be able to go into
  # that POI's images folder to view all the managers uploaded images.
  #
  def show_images
    @poi = Poi.find(params[:id])
  end

  # Public: This creates an empty POI to be able to create a new one given.
  #
  def new
    @poi = Poi.new
  end

  # Public: This creates a POI given all the information filled out. It also creates many new
  # folders for the new POI. It creates an image folder named "poi.id_images". With in that,
  # it creates "user_images" and "title_image" folders. Then within the "user_images" folders,
  # it creates 2 more folders named "approved" and "disapproved". If the user uploaded an image
  # when creating the POI, it makes that image the title image and puts it in the "title_image"
  # folder. 
  #
  def create
    @poi = Poi.new(poi_params)

    respond_to do |format|
      if @poi.save
        path_name = "#{Rails.root}/public/images/#{@poi.id}_images/"
        path_name_user = "#{Rails.root}/public/images/#{@poi.id}_images/user_images/"
        path_name_title_image = "#{Rails.root}/public/images/#{@poi.id}_images/title_image/"
        
        path_image_approve = "#{Rails.root}/public/images/#{@poi.id}_images/user_images/approved"
        path_image_disapprove = "#{Rails.root}/public/images/#{@poi.id}_images/user_images/disapproved"
        
        FileUtils.mkdir_p(path_name)
        FileUtils.mkdir_p(path_name_user)
        FileUtils.mkdir_p(path_name_title_image)
        
        FileUtils.mkdir_p(path_image_approve)
        FileUtils.mkdir_p(path_image_disapprove)

        if params[:poi]['file'] != nil
          Poi.super_with_name(params[:poi], "_poi_", path_name_title_image)

          format.html { redirect_to show_images_path(@poi.id), notice: 'Poi was successfully created. Now upload all your other images here.' }
          format.json { render action: 'show', status: :created, location: @poi }
        else
          format.html { redirect_to show_images_path(@poi.id), notice: 'Poi was successfully created. Now upload all your other images here.' }
          format.json { render action: 'show', status: :created, location: @poi }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # Public: This updates the given POI with all the new information.
  #
  def update
    respond_to do |format|
      if @poi.update(poi_params)
        format.html { redirect_to @poi, notice: " #{@poi.title} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # Public: This uploades the image given to the given POI, found by the id in the url.
  #
  def upload_image
    respond_to do |format|
      if params[:poi]['file'] != nil
        poi_id = params[:poi]['poi_id']
        path_name = "#{Rails.root}/public/images/#{poi_id}_images/"

        FileUtils.mkdir_p(path_name) if !File.exist?(path_name)
        Poi.super_with_name(params[:poi], "_poi_", path_name)

        format.html { redirect_to show_images_path(poi_id), notice: ' Image was successfully added.' }
        format.json { head :no_content }
      else
        update
      end
    end
  end

  # Public: This destroies the POI given by the id in the url. It also deletes the
  # "poi.id_images" folder, so in turn deletes all of its sub folders.
  #
  def destroy
    @poi.destroy
    FileUtils.remove_dir "#{Rails.root}/public/images/#{@poi.id}_images"
    respond_to do |format|
      format.html { redirect_to show_all_path }
      format.json { head :no_content }
    end
  end

  # Public: This deletes the wanted image.
  #
  def delete_image
    ext = "." + "#{params[:format]}"
    file_name = "#{Rails.root}/public/images/#{params[:poi_id]}_images/#{params[:file_name]}#{ext}"
    File.delete(file_name) if File.file?(file_name)
    redirect_to show_images_path(params[:poi_id])
  end
  
  # Public: This moves the old title image to the "poi.id_images" folder and moves the new wanted 
  # image to the "title_image" folder.
  #
  def new_title_image
    if params[:title_image] != nil
      # Moves the old image to the image folder
      old_title_image_path = "#{Rails.root}/public/images/#{params[:id]}_images/title_image/#{params[:poi]['current_title_image']}"
      old_title_image_new_path = "#{Rails.root}/public/images/#{params[:id]}_images/#{params[:poi]['current_title_image']}"
      FileUtils.mv(old_title_image_path, old_title_image_new_path)
      
      # Moves the wanted image to the title image folder
      new_title_image_path = "#{Rails.root}/public/images/#{params[:id]}_images/#{params[:title_image]}"
      new_title_image_new_path = "#{Rails.root}/public/images/#{params[:id]}_images/title_image/#{params[:title_image]}"
      FileUtils.mv(new_title_image_path, new_title_image_new_path)
    end
    
    redirect_to show_images_path(params[:id])
  end
  
  # Public: This updates the rating information of the given POI by the id in 
  # the url. 
  #
  def update_rating
    @poi = Poi.find(params[:id])
    total_ratings = @poi.total_ratings.to_i + params[:rating].to_i
    number_people = @poi.total_people.to_i + 1
    new_avg = total_ratings.to_i / number_people.to_i
    
    @poi.update_attribute(:total_ratings, total_ratings.to_i)
    @poi.update_attribute(:total_people, number_people.to_i)
    @poi.update_attribute(:avg_rating, new_avg.to_i)
    
    redirect_to @poi
  end

  private

    def set_poi
      @poi = Poi.find(params[:id])
    end
  
    def poi_params
      params.require(:poi).permit(:title, :address, :sponsor, :description, :latitude, :longitude, :user_id)
    end
    
    def poi_rating_params
      params.require(:poi).permit(:total_people)
    end
    
end
