class Poi < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  geocoded_by :address
  after_validation :geocode
  attr_accessor :img

  validates :title, presence: true, length: { maximum: 50 }
  validates :sponsor, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 240 }
  validate :address
  
  validate :check_address_or_lat_long

  cattr_accessor :poi_home_image
  cattr_accessor :poi_counter
  
  @@poi_home_image = false
  @@poi_counter = 0
  
  # Public: This checks to see if either the user filled out the lat and long or the
  # address of the new POI. 
  #
  # * *Returns* :
  #   - true is the address or lat and long are filled out.
  #
  def check_address_or_lat_long
    if address.blank? and latitude.blank? and longitude.blank?
      return false
    elsif !address.blank? and latitude.blank? and longitude.blank?
      return true
    elsif address.blank? and !latitude.blank? and !longitude.blank?
      return true
    elsif !address.blank? and !latitude.blank? and !longitude.blank?
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
  def self.super_without_name(upload, file_name, path_name)
    name = file_name
    path = File.join(path_name,name)
    File.open(path, 'wb') do |file|
      file.write(upload[:file].read)
    end
  end

  # Public: This will take the image uploaded with its name appended with the file name passed 
  # in infront of it and save it to the path name that was given.
  #
  # * *Args*    :
  #   - +upload+ -> This is the object that holds the image that was uploaded.
  #   - +file_name+ -> This is the file name that the file is going to have.
  #   - +path_name+ ->  This is the path name of the file to be put in.
  #
  def self.super_with_name(upload, file_name, path_name)
    name = file_name + upload[:file].original_filename.downcase
    path = File.join(path_name,name)
    File.open(path, 'wb') do |file|
      file.write(upload[:file].read)
    end
  end

end

