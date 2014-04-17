class Comment < ActiveRecord::Base
  
  validates :text, presence: true, length: { maximum: 240 }
  
  cattr_accessor :comment_image
  @@comment_image = false
end
