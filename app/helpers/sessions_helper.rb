module SessionsHelper
  
  # Public: This is what signs in the user and sets the current_user to the now 
  # signed in user
  #
  # * *Args*    :
  #   - +user+ -> The user to set the current_user to.
  #
  def sign_in(user)
    self.current_user = user
  end

  # Public: This sets the current_user that is currently signed in to the site.
  #
  # * *Returns* :
  #   - current_user The current_user that is signed in.
  #
  def current_user=(user)
    @current_user = user
  end

  # Public: This gets the current_user that is currently signed in to the site.
  #
  # * *Returns* :
  #   - current_user The current_user that is signed in.
  #
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end
  
end
