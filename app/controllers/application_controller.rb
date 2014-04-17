class ApplicationController < ActionController::Base
  cattr_accessor :remember_me
  helper_method :current_user
  has_mobile_fu
  
  # Public: This gets the current user that is logged in into the website.
  #
  # * *Returns* :
  #   - current_user The user logged in.
  #
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
    @current_user ||= User.find_by_remember_me(cookies[:remember_me]) if cookies[:remember_me] && @current_user.nil?
    @current_user
  end

  # Public: This helps get the check box if the user signing in wants to be remembered or not.
  #
  # * *Args*    :
  #   - +user+ -> This is the user signing in.
  #   - +remember_me+ -> This is a value if the user wants to be remebered or not.
  #
  def update_remember_me(user, remember_me)
    if remember_me == 1
      remember_me = SecureRandom.urlsafe_base64
      user.remember_me = remember_me
      cookies.permanent[:remember_me] = remember_me
    else
      user.remember_me = nil
      cookies.permanent[:remember_me] = nil
    end
  end

  # Public: This prepares all the views for when someone gets on the site
  # using a mobile device.
  #
  # * *Returns* :
  #   - mobile The format of the mobile views if viewed on mobile device.
  #
  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end

  # Public: This is for when someone wants to request for an manager roles.
  #
  def request_role
    @user = User.find(params[:id])
    @admin = User.find_by_roles("Admin")
    @user.update_attribute(:is_approved, false)
    UserMailer.request_artist(@user, @admin).deliver
    redirect_to root_url
  end

  private

  def mobile_device?
    request.user_agent =~ /Mobile|webOS/
  end
  helper_method :mobile_device?
end