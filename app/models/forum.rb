class Forum < ActiveRecord::Base
  has_many :subforums

  validates :forumname, presence: true

end
