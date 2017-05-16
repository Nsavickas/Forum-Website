class Avatar < ActiveRecord::Base
  belongs_to :user
  has_attached_file :displaypic, styles: { small: "64x64", med: "200x200", large: "1920x1080" }
  
  
  validates_attachment :displaypic, :presence => true, 
                       :content_type => {:content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]},
                       size: { less_than: 5.megabytes }
  validates :user_id, :presence => true
  
end
