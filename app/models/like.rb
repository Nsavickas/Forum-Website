class Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true
  belongs_to :user
  has_many :notifications, as: :notifiable, dependent: :destroy
  
  delegate :name, :to => :user, :prefix => true
  
  validates :likeable_id, presence: true
  validates :likeable_type, presence: true
  validates :user_id, presence: true
  
  before_save :check_duplicate
  
  scope :liked_posts, -> { where(likeable_type: "Post") }
  scope :liked_comments, -> { where(likeable_type: "Comment") }
  
  def get_liked_media
    if likeable_type == 'Post'
      media = Post.find(likeable_id)
    elsif likeable_type == 'Comment'
      media = Comment.find(likeable_id)
    end
  end
  
  private

  def check_duplicate
    (Like.where(likeable_type: self.likeable_type, 
                  likeable_id: self.likeable_id, 
                      user_id: self.user_id ).exists?) ? false : true
  end
  
end
