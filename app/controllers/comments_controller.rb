require 'fileutils'

class CommentsController < ApplicationController
  
  # Public: This gets all the POI's and comments for the index view to use.
  #
  def index
    @poi = Poi.all
    @comment = Comment.all
  end
  
  # Public: This gets the POI that is passed in by the url and it gets all the
  # users for the poi_comments view to use.
  #
  def poi_comments
    @poi = Poi.find(params[:id])
    @users = User.all
  end
  
  # Public: This gets all the information needed to create a new comment for the
  # POI's id, passed in by the url. If the user added an image, it will upload that
  # image to the disapproved image folder of that POI. It also sends the admin a email
  # saying that someone has uploaded an image to that POI.
  #
  def create
    @poi = Poi.find(params[:comment][:poi_id])
    @admin = User.find_by_roles("Admin")
    @comment = @poi.comments.create(comment_params)
    
    path_name = "#{Rails.root}/public/images/#{@poi.id}_images/user_images/disapproved"
    file_name = "#{@comment.id}"
    
    if params[:comment]['file'] != nil
      UserMailer.image_approve(@poi, @admin).deliver
      Poi.super_without_name(params[:comment], file_name, path_name)
    end
    
    redirect_to poi_path(@poi)
  end
  
  # Public: This will upload the given image to the disapproved image folder of that POI, 
  # that is passed in by the url. It also sends the admin a email
  # saying that someone has uploaded an image to that POI.
  #
  def user_upload_image
    @poi = Poi.find(params[:comment][:poi_id])
    @admin = User.find_by_roles("Admin")
    path_name = "#{Rails.root}/public/images/#{@poi.id}_images/user_images/disapproved"
    
    if params[:comment]['file'] != nil
      UserMailer.image_approve(@poi, @admin).deliver
      Poi.super_with_name(params[:comment], "", path_name)
    end
    
    redirect_to poi_path(@poi)
  end
  
  # Public: This destroies the given comment by the comment id, given by 
  # the url.
  #
  def destroy
    @poi = Poi.find(params[:poi_id])
    @comment = @poi.comments.find(params[:id])
    @comment.destroy
    redirect_to show_comments_path(@poi)
  end
  
  # Public: This allows the upapproved_images view to find the POI with the 
  # given id, given by the url.
  #
  def unapproved_images
    @poi = Poi.find(params[:id])
  end
  
  # Public: This allows the approved_images view to find the POI with the 
  # given id, given by the url.
  #
  def approved_images
    @poi = Poi.find(params[:id])
  end
  
  # Public: This moves the given image, image that was uploaded by a user as a comment,
  # to the approved images folder from the poi, given the id by the url.
  #
  def approve_image
    @poi = Poi.find(params[:id])
    
    ext = "." + "#{params[:format]}"
    file_name_old = "#{Rails.root}/public/images/#{params[:id]}_images/user_images/disapproved/#{params[:file_name]}#{ext}"
    file_name_new = "#{Rails.root}/public/images/#{params[:id]}_images/user_images/approved/#{params[:file_name]}#{ext}"
    FileUtils.mv(file_name_old, file_name_new) if File.file?(file_name_old)
    
    redirect_to show_unapproved_images_path(@poi), notice: ' Image was successfully approved.'
  end
  
  # Public: This deletes the given image, image that was uploaded by a user as a comment,
  # from the poi, given the id by the url.
  #
  def disapprove_image
    @poi = Poi.find(params[:id])
    
    ext = "." + "#{params[:format]}"
    file_name = "#{Rails.root}/public/images/#{params[:id]}_images/user_images/disapproved/#{params[:file_name]}#{ext}"
    File.delete(file_name) if File.file?(file_name)
    
    redirect_to show_unapproved_images_path(@poi), notice: ' Image was not approved so was removed.'
  end
  
  # Public: This deletes the given image, image that was approved by an admin as a comment,
  # from the poi, given the id by the url.
  #
  def delete_approved_image
    @poi = Poi.find(params[:id])
    
    ext = "." + "#{params[:format]}"
    file_name = "#{Rails.root}/public/images/#{params[:id]}_images/user_images/approved/#{params[:file_name]}#{ext}"
    File.delete(file_name) if File.file?(file_name)
    
    redirect_to show_approved_images_path(@poi), notice: ' Image was successfully removed.'
  end
  
  private

    def comment_params
      params.require(:comment).permit(:user_id, :poi_id, :text)
    end
end
