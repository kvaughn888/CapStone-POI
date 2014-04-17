class UserMailer < ActionMailer::Base
  default :from => "no_reply@gmail.com"
  
  # Public: This is what sends the email to reset a user's password.
  #
  # * *Args*    :
  #   - +user+ -> The user that is getting the email.
  #
  def reset_password_email(user)
    @user = user
    @password_reset_url = 'http://localhost:3000/password_reset?' + @user.password_reset_token
    mail(:to => @user.email, :subject => "Password Reset Instructions.")
  end
  
  # Public: This emails the admin and tells them the user has requested to become a manager
  # on the site.
  #
  # * *Args*    :
  #   - +user+ -> The user that is requesting to become a manager.
  #   - +admin+ -> The admin that will have to approve/disapprove manager request.
  #
  def request_artist(user, admin)
    @user = user
    @admin = admin
    @approve = "http://localhost:3000/users"
    mail(:to => @admin.email, :subject => "#{@user.name} needs to be approved.")
  end
  
  # Public: This emails the user that requested to become a manager that the admin did
  # appove them to become one.
  #
  # * *Args*    :
  #   - +user+ -> The user that is now approved to become a manager.
  #
  def yes_approved(user)
    @user = user
    @url_sign = "http://localhost:3000/sessions/login"
    mail(:to => @user.email, :subject => "You have been approved!")
  end
  
  # Public: This emails the user that requested to become a manager that the admin did not
  # appove them to become one.
  #
  # * *Args*    :
  #   - +user+ -> The user that is not approved to become a manager.
  #
  def no_approved(user)
    @user = user
    mail(:to => @user.email, :subject => "You have not been approved.")
  end
  
  # Public: This emails the admin and tells them that their is now a POI that someone uploaded 
  # an image to and it needs to be approved/disapproved. 
  #
  # * *Args*    :
  #   - +poi+ -> The poi that has a new user uploaded image.
  #   - +admin+ -> The admin that is getting the email for image approve/disapprove.
  #
  def image_approve(poi, admin)
    @poi = poi
    @admin = admin
    @image_approve_url = "http://localhost:3000/comments/comment_images/#{@poi.id}"
    mail(:to => @admin.email, :subject => "#{@poi.title} needs an image that needs to be approved.")
  end
end
