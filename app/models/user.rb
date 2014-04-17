class User < ActiveRecord::Base
  cattr_accessor :password
  before_save :encrypt_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :name, presence: true, length: { maximum: 50 }
  validates :password, presence: true, length: { minimum: 8, maximum: 24 }

  cattr_accessor :has_image
  @@has_image = false
  
  # Public: This is what encrypts the password of users.
  #
  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.password= BCrypt::Engine.hash_secret(password, salt)
    end
  end

  # Public: This authenticates the user by decrypting the password and making sure
  # it is corrent. It finds the user with the email and login_password passed in. 
  #
  # * *Args*    :
  #   - +email+ -> The email the user put in to login in with.
  #   - +login_password+ -> The password the user put in to login in with.
  # * *Returns* :
  #   - true if the passwords are correct.
  #
  def self.authenticate(email, login_password)
    user = User.find_by_email(email)
    if user && user.password == password
      return user
    end
    else if user && user.password == BCrypt::Engine.hash_secret(password, user.salt)
      return user
    else
      return false
    end
  end

  # Public: This will take the image uploaded and give it just the name of the file name passed in
  # and save it to the path name that was given.
  #
  # * *Args*    :
  #   - +upload+ -> This is the object that holds the image that was uploaded.
  #   - +file_name+ -> This is the file name that the file is going to have.
  #   - +path_name+ ->  This is the path name of the file to be put in.
  #
  def self.super(upload, file_name, path_name)
    name = file_name
    path = File.join(path_name,name)
    File.open(path, 'wb') do |file|
      file.write(upload[:file].read)
    end
  end

  # Public: This authenticates the user when the user signs in the site using one of the 
  # social media sites. It then sets the current_user to that user if it all checks out ok.
  #
  # * *Args*    :
  #   - +auth+ -> The authenticate code for the social media site used to login in. 
  #
  def self.from_omniauth(auth)
    @user = User.find_by_email(auth.info.email)
    if @user == nil
      where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
        user.name = auth.info.name
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.roles = "User"
        user.save!
      end
    else
      @current_user = @user
    end
  end

end
