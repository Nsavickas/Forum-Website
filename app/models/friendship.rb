class Friendship < ActiveRecord::Base
  belongs_to :friender, class_name: "User", :foreign_key => :friender_id
  belongs_to :friended, class_name: "User", :foreign_key => :friended_id
  has_many :notifications, as: :notifiable, dependent: :destroy

  validates :friender_id, presence: true
  validates :friended_id, presence: true

  scope :accepted, -> {where(accepted: true)}
  scope :pending, -> {where(accepted: false)}


  ################## CLASS METHODS ###################

  #returns Friendships where 'user_id' is the User that initiated the Friend Request
  def self.getOutgoingFriendships(user_id)
    where("friender_id = :user_id", {user_id: user_id})
  end

  #returns Friendships where 'user_id' is the User that received the Friend Request
  def self.getIncomingFriendships(user_id)
    where("friended_id = :user_id", {user_id: user_id})
  end

  #returns all Friendships that involve 'user_id'
  def self.getMutualFriendships(user_id)
    where('friended_id = :user_id OR friender_id = :user_id', {user_id: user_id})
    #where('friended_id = ? AND friender_id = ? OR friended_id = ? AND friender_id = ?', user_id, current_user_id, current_user_id, user_id)
  end

  #returns Friendship between specified Users (mainly to display AddFriend vs. RemoveFriend vs. AcceptFriend)
  def self.getFriendshipStatus(user1, user2)
    where('friended_id = :user1 AND friender_id = :user2 OR friended_id = :user2 AND friender_id = :user1', {user1: user1, user2: user2})
  end

  ################ INSTANCE METHODS ##################

  #returns the Friend of 'user_id' for a given Friendship
  def getFriend(user_id)
    friender_id == user_id ? friended : friender
  end
end
