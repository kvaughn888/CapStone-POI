require 'test_helper'

class PoiTest < ActiveSupport::TestCase
  def test_empty_poi_fails
    poi = Poi.new
    assert !poi.save
  end
  
  def test_poi_passes
    poi1 = Poi.new(:title => "wolf", :address => "123 street", :sponsor => "uwg", :description => "here it is", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert poi1.save
  end
  
  def test_no_title_fails
    poi1 = Poi.new(:address => "123 street", :sponsor => "uwg", :description => "here it is", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert !poi1.save
  end
  
  def test_no_sponsor_fails
    poi1 = Poi.new(:title => "wolf", :address => "123 street", :description => "here it is", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert !poi1.save
  end
  
  def test_no_description_fails
    poi1 = Poi.new(:title => "wolf", :address => "123 street", :sponsor => "uwg", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert !poi1.save
  end
  
  def test_no_lat_fails
    poi1 = Poi.new(:title => "wolf", :address => "123 street", :sponsor => "uwg", :description => "here it is", :longitude => 20.1, :user_id => 1)
    assert_not poi1.check_address_or_lat_long
  end
  
  def test_no_long_fails
    poi1 = Poi.new(:title => "wolf", :address => "123 street", :sponsor => "uwg", :description => "here it is", :latitude => 13, :user_id => 1)
    assert_not poi1.check_address_or_lat_long
  end
  
  def test_no_address_passes
    poi1 = Poi.new(:title => "wolf", :sponsor => "uwg", :description => "here it is", :latitude => 10, :longitude => 20.1, :user_id => 1)
    assert poi1.check_address_or_lat_long
  end
  
  def test_poi_with_49_title_passes
    poi1 = Poi.new(:title => "0123456789012345678901234567890123456789012345678", :address => "123 street", :sponsor => "uwg", :description => "here it is", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert poi1.save
  end
  
  def test_poi_with_50_title_passes
    poi1 = Poi.new(:title => "01234567890123456789012345678901234567890123456789", :address => "123 street", :sponsor => "uwg", :description => "here it is", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert poi1.save
  end
  
  def test_poi_with_51_title_fails
    poi1 = Poi.new(:title => "012345678901234567890123456789012345678901234567890", :address => "123 street", :sponsor => "uwg", :description => "here it is", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert_not poi1.save
  end
  
   def test_poi_with_49_sponsor_passes
    poi1 = Poi.new(:title => "uwg", :address => "123 street", :sponsor => "0123456789012345678901234567890123456789012345678", :description => "here it is", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert poi1.save
  end
  
  def test_poi_with_50_sponsor_passes
    poi1 = Poi.new(:title => "uwg", :address => "123 street", :sponsor => "01234567890123456789012345678901234567890123456789", :description => "here it is", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert poi1.save
  end
  
  def test_poi_with_51_sponsor_fails
    poi1 = Poi.new(:title => "uwg", :address => "123 street", :sponsor => "012345678901234567890123456789012345678901234567890", :description => "here it is", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert_not poi1.save
  end
  
  def test_poi_with_239_description_passes
    poi1 = Poi.new(:title => "uwg", :address => "123 street", :sponsor => "uwg", :description => "01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert poi1.save
  end
  
  def test_poi_with_240_description_passes
    poi1 = Poi.new(:title => "uwg", :address => "123 street", :sponsor => "uwg", :description => "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert poi1.save
  end
  
  def test_poi_with_241_description_fails
    poi1 = Poi.new(:title => "uwg", :address => "123 street", :sponsor => "uwg", :description => "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890", :latitude => 10.0, :longitude => 20.1, :user_id => 1)
    assert_not poi1.save
  end
  
  
end
