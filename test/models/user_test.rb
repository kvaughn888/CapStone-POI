require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
  end

  
  def test_empty_user_fails
    user = User.new
    assert !user.save
  end
  
  def test_user_passes
    user1 = User.new(:name => "Bob", :email => "bob123@gmail.com", :password => "12345678", :roles => "Artist", :is_approved => true)
    assert user1.save
  end
  
  def test_encrypt_password
    assert_not_equal( "12345678", User.new(:name => "Bob", :email => "bob123@gmail.com", :password => "12345678", :roles => "Artist", :is_approved => true).encrypt_password)
  end
  
  def test_email_passed
    assert User.new(:name => "Bob", :email => "bob123@yahoo.com", :password => "12345678", :roles => "Artist", :is_approved => true).save
  end
  
  def test_email_failed
    assert_not User.new(:name => "Bob", :email => " ", :password => "12345678", :roles => "Artist", :is_approved => true).save
  end
  
  def test_email_invalid_fails
    assert_not User.new(:name => "Bob", :email => "stuffgmailcom", :password => "12345678", :roles => "Artist", :is_approved => true).save
  end
  
  def test_email_invalid_with_at_fails
    assert_not User.new(:name => "Bob", :email => "stuff@gmailcom", :password => "12345678", :roles => "Artist", :is_approved => true).save
  end
  
  def test_email_invalid_with_only_period_fails
    assert_not User.new(:name => "Bob", :email => "stuffgmail.com", :password => "12345678", :roles => "Artist", :is_approved => true).save
  end
  
  def test_password_passed
    assert User.new(:name => "Bob", :email => "bob123@yahoo.com", :password => "12345678", :roles => "Artist", :is_approved => true).save
  end
    
  def test_password_failed
   assert_not User.new(:name => "Bob", :email => "bob123@yahoo.com", :password => "12", :roles => "Artist", :is_approved => true).save
  end
  
  def test_password_23_passes
   assert User.new(:name => "Bob", :email => "bob123@yahoo.com", :password => "12345678912345678912345", :roles => "Artist", :is_approved => true).save
  end
  
  def test_password_24_passes
   assert User.new(:name => "Bob", :email => "bob123@yahoo.com", :password => "123456789123456789123456", :roles => "Artist", :is_approved => true).save
  end
  
  def test_password_25_fails
   assert_not User.new(:name => "Bob", :email => "bob123@yahoo.com", :password => "1234567891234567891234567", :roles => "Artist", :is_approved => true).save
  end
      
end
