require 'fileutils'

class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # Public: This gets all the users in the database for the index view to use them.
  #
  def index
    @users = User.all
  end

  # Public: This creates a new empty user for the new view to be able to get all the 
  # fields it needs to create a new user.
  #
  def new
    @user = User.new
  end

  # Public: This is what takes all the information given and creates a new user. It will also 
  # send an email to the admins of the site if the user requested to become a manager of a POI.
  #
  def create
    @user = User.new(user_params)
    @admin = User.find_by_roles("Admin")

    respond_to do |format|
      if @user.save
        if @user.roles == "Artist"
          @user.update_attribute(:roles, "User")
          @user.update_attribute(:is_approved, false)
          UserMailer.request_artist(@user, @admin).deliver
          
          format.html { redirect_to :root, notice: 'You have been given the default user profile until you are approved by the admin.' }
          format.json { render action: 'show', status: :created, location: @user }
        else
          format.html { redirect_to :root, notice: 'User was successfully created.' }
          format.json { render action: 'show', status: :created, location: @user }
        end
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Public: This is what updates the user's information when the user wants to edit it. It 
  # will also update their profile image if they uploaded an image as well. 
  #
  def update
    respond_to do |format|
      if @user.update(user_params_more)
        if params[:user]['file'] != nil
          user_id = params[:user]['user_id']
          path_name = "#{Rails.root}/public/profile_images/"
          file_name = "#{user_id}"
          
          FileUtils.mkdir_p(path_name) if !File.exist?(path_name)
          
          User.super(params[:user], file_name, path_name)
          
          format.html { redirect_to user_path(user_id), notice: 'Your profile image was successfully added.' }
          format.json { head :no_content }
        else
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { head :no_content }
        end
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Public: This is what destroies the wanted user given the id of the user given from 
  # the url.
  #
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end
  
  # Public: This is what approves the user to become a manager of POI's on the site. It will 
  # send an email to the user saying that they can now add POI's to the site.
  #
  def approve
    @user = User.find(params[:id])
    @user.update_attribute(:roles, "Artist")
    @user.update_attribute(:is_approved, true)
    respond_to do |format|
      UserMailer.yes_approved(@user).deliver
      format.html { redirect_to users_url, notice: 'User was successfully approved to become an artist.' }
      format.json { head :no_content }
    end
  end
  
  # Public: This is what disapproves a user from becoming a manager of POI's. It will send an 
  # email to the user saying they were not approved to become a manager. 
  #
  def disapprove
    @user = User.find(params[:id])
    @user.update_attribute(:roles, "User")
    @user.update_attribute(:is_approved, true)
    respond_to do |format|
      UserMailer.no_approved(@user).deliver
      format.html { redirect_to users_url, notice: 'User was disapproved on becoming an artist.' }
      format.json { head :no_content }
    end
  end
  
  # Public: This is what allows a user to request a new role after that have
  # already created a profile. 
  #
  def edit_role
    @user = User.find(params[:id])
  end
  
  # Public: This is what really updates the users role after they request to become 
  # a manager.
  #
  def update_role
    @user = User.find(params[:id])
    @user.update_attribute(:roles, params[:wanted_role])
    redirect_to users_path
  end

  private
  
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :roles, :is_approved)
    end
    
    def user_params_more
      params.require(:user).permit(:name, :email, :password, :roles, :address1, :address2, :city, :state, :zip, :phone1, :phone2, :phone3, :website, :age, :sex, :bio)
    end
end
