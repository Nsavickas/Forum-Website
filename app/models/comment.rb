class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :post, counter_cache: true

  has_many :likes, as: :likeable, :dependent => :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :comment_content, presence: true,
            length: {minimum: 2}
  validates :user_id, presence: true
  validates :post_id, presence: true

end
