class Message < ActiveRecord::Base

  validates :recipient, presence: true
  validates :subject, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 240 }

end
