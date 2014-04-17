require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def test_empty_comment_fails
    comment = Comment.new
    assert !comment.save
  end
  
  def test_message_passes
    comment = Comment.new(:user_id => "1", :poi_id => "2", :text => "asdf")
    assert comment.save
  end
  
  def test_comment_with_239_text_passes
    comment = Comment.new(:user_id => "1", :poi_id => "2", :text => "asdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjklpasdfghjkloiuytrewsdfghjkloiuy")
    assert comment.save
  end
  
  def test_comment_with_240_text_passes
    comment = Comment.new(:user_id => "1", :poi_id => "2", :text => "aasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjklpasdfghjkloiuytrewsdfghjkloiuy")
    assert comment.save
  end
  
  def test_comment_with_241_text_fails
    comment = Comment.new(:user_id => "1", :poi_id => "2", :text => "aaasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjkloasdfghjklpasdfghjkloiuytrewsdfghjkloiuy")
    assert_not comment.save
  end
  
  
end
