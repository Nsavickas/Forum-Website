class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  
  validates :user_id, :presence => true
  validates :notifiable_id, :presence => true
  validates :notifiable_type, :presence => true
  validates :title, :presence => true
  
  scope :viewed, -> {where(viewed: true)}
  scope :unviewed, -> {where(viewed: false)}
  
end
