class Subforum < ActiveRecord::Base
  belongs_to :forum
  has_many :posts, :dependent => :destroy

  delegate :forumname, :to => :forum, :prefix => false

  def most_recent_post
    Post.where('subforum_id = ?', self.id).last
  end

  def self.find_by_name(forumname)
    Subforum.where('forumname = ?', forumname)
  end

  validates :subforumname, presence: true
  validates :forum_id, presence: true

end
