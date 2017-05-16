class Friendship < ActiveRecord::Base
  belongs_to :friender, class_name: "User", :foreign_key => :friender_id
  belongs_to :friended, class_name: "User", :foreign_key => :friended_id
  has_many :notifications, as: :notifiable, dependent: :destroy
  
  delegate :name, :to => :friender, :prefix => true
  delegate :name, :to => :friended, :prefix => true
  delegate :avatar_displaypic, :to => :friender, :prefix => true
  delegate :avatar_displaypic, :to => :friended, :prefix => true
  
  validates :friender_id, presence: true
  validates :friended_id, presence: true
  
  scope :accepted, -> {where(accepted: true)}
  scope :pending, -> {where(accepted: false)}
  
  def self.get_friender_friendships(user)
    where("friender_id = :user_id", {user_id: user.id})
  end
  
  def self.get_friended_friendships(user)
    where("friended_id = :user_id", {user_id: user.id})
  end
  
  def self.get_mutual_friendship(user_id, current_user_id)
    where('friended_id = ? AND friender_id = ? OR friended_id = ? AND friender_id = ?', 
    user_id, current_user_id, current_user_id, user_id)
  end
  
  def get_friend(current_user_id)
    if friender_id == current_user_id
      @friended_user = friended
    else
      @friended_user = friender
    end 
  end
end
