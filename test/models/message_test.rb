require 'test_helper'

class MessageTest < ActiveSupport::TestCase
  def test_empty_message_fails
    message = Message.new
    assert !message.save
  end
  
  def test_message_passes
    message = Message.new(:subject => "blah", :body=> "hey", :sender => "tom", :recipient => "bob", :has_read => true)
    assert message.save
  end
  
  def test_no_subject_fails
    message = Message.new(:body=> "hey", :sender => "tom", :recipient => "bob", :has_read => true)
    assert_not message.save
  end
  
  def test_no_body_fails
    message = Message.new(:subject => "hey", :sender => "tom", :recipient => "bob", :has_read => true)
    assert_not message.save
  end
  
  def test_no_recipient_fails
    message = Message.new(:subject => "hey", :body => "whats up?", :sender => "tom", :has_read => true)
    assert_not message.save
  end
  
  def test_message_with_49_subject_passes
    message = Message.new(:subject => "asdfghjklpasdfghjklpasdfghjklpasdfghjklpasdfghjkl", :body=> "hey", :sender => "tom", :recipient => "bob", :has_read => true)
    assert message.save
  end
  
  def test_message_with_50_subject_passes
    message = Message.new(:subject => "asdfghjklpasdfghjklpasdfghjklpasdfghjklpasdfghjklp", :body=> "hey", :sender => "tom", :recipient => "bob", :has_read => true)
    assert message.save
  end
  
  def test_message_with_51_subject_fails
    message = Message.new(:subject => "asdfghjklpasdfghjklpasdfghjklpasdfghjklpasdfghjklpa", :body=> "hey", :sender => "tom", :recipient => "bob", :has_read => true)
    assert_not message.save
  end
  
  def test_message_with_239_body_passes
    message = Message.new(:subject => "blah", :body=> "asdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjklpasdfghjkloiuytrewsdfghjkloiuy", :sender => "tom", :recipient => "bob", :has_read => true)
    assert message.save
  end
  
  def test_message_with_240_body_passes
    message = Message.new(:subject => "blah", :body=> "aasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjklpasdfghjkloiuytrewsdfghjkloiuy", :sender => "tom", :recipient => "bob", :has_read => true)
    assert message.save
  end
  
  def test_message_with_241_body_fails
    message = Message.new(:subject => "blah", :body=> "asdsdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjklpasdfghjkloiuytrewsdfghjkloiuy", :sender => "tom", :recipient => "bob", :has_read => true)
    assert_not message.save
  end
  
end
