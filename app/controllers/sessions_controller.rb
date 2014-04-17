class SessionsController < ApplicationController
  
  # Public: This shows the users profile page when they are signed into the site using a 
  # social media site. 
  #
  def profile
    session[:user_id] = user.id
  end

  # Public: This creates a new user when someone that has never logged into the site using
  # a social media site. 
  #
  def sign_in
    @user = User.new
  end

  # Public: This is what logs a user out when they are signed in with one of the social 
  # media sites.
  #
  def logout
    user = User.find_by_id(session[:user_id])
    update_remember_me(user, nil)
    session[:user_id] = nil
    redirect_to :action => 'login'
  end

  # Public: This creates a new profile for someone that has never logged into the site
  # using one of the social media sites.
  #
  def create
    email = params[:sessions]["email"]
    password = params[:sessions]["password"]

    user = User.authenticate(email, password)
    
    respond_to do |format|
      if user
        update_remember_me(user, params[:sessions]["remember_me"])
        session[:user_id] = user.id
        format.html { redirect_to root_path, notice: ' Welcome back!' }
      else
        format.html { render action: 'login' }
        format.json { render json: @poi.errors, status: :unprocessable_entity }
      end
    end
  end

  # Public: This is what creates the integration with all the social media sites.
  #
  def create_integration
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    if user.email == nil
      redirect_to edit_user_path(user)
    else
      redirect_to root_path
    end
  end

  # Public: This is what destroies the session, when someone using a social media site 
  # logs out of the site. 
  #
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  # Public: This creates a new user so that the forgot_password view can use it
  # to get the email of the user that forgot their password and pass it to the 
  # following view.
  #
  def forgot_password
    @user = User.new
  end

  # Public: This will get the email given by the forgot_password view, and make the call
  # to send the email with the instructions to reset that uses password. 
  #
  # HTTP put
  def send_password_reset_instructions
    email = params[:sessions]["email"]
    @user = User.find_by_email(email)

    if @user.present?
      @user.password_reset_token = SecureRandom.urlsafe_base64
      @user.password_expires_after = 24.hours.from_now
      @user.save
      UserMailer.reset_password_email(@user).deliver
      flash[:notice] = "Password instructions have been mailed to you. Please check your inbox."
      redirect_to :sign_in
    else
      @user = User.new
      @user.name = params[:sessions]["name"]
      @user.errors["name"] = 'is not a registered user.'
      render :action => "forgot_password"
    end
  end

  # Public: This is what will the user will get if their password reset tokens
  # have expired. 
  #
  def password_reset
    token = params.first[0]
    @user = User.find_by_password_reset_token(token)

    if @user.nil?
      flash[:error] = 'You have not requested a password reset.'
      redirect_to :root
    return
    end

    if @user.password_expires_after < DateTime.now
      clear_password_reset(@user)
      @user.save
      flash[:error] = 'Password reset has expired. Please request a new password reset.'
      redirect_to :forgot_password
    end
  end

  # Public: This is what will reset the users password when the user submits it. It also 
  # resets the forgot password tokens.
  #
  def new_password
    @user = User.find_by_email(params[:user][:email])

    if verify_new_password(params[:user])
      @user.update_attributes(user_params)
      @user.password = params[:user][:new_password]

      if @user.valid?
        clear_password_reset(@user)
        @user.save
        flash[:notice] = 'Your password has been reset. Please sign in with your new password.'
        redirect_to :sign_in
      else
        render :action => "password_reset"
      end
    else
      @user.errors[:new_password] = 'Cannot be blank and must match the password verification.'
      render :action => "password_reset"
    end
  end

  private

    def clear_password_reset(user)
      user.password_expires_after = nil
      user.password_reset_token = nil
    end
  
    def verify_new_password(passwords)
      result = true
  
      if passwords[:new_password].blank? || (passwords[:new_password] != passwords[:new_password_confirmation])
        result = false
      end
      result
    end
  
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
