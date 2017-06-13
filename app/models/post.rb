class Post < ActiveRecord::Base
  #include Impressionist::IsImpressionable
  #is_impressionable :counter_cache => true, :column_name => :views_count, :unique => true

  belongs_to :user
  belongs_to :subforum
  has_many :comments, :dependent => :destroy
  has_many :pictures, as: :imageable, :dependent => :destroy
  has_many :likes, as: :likeable, :dependent => :destroy

  delegate :name, :to => :user, :prefix => true
  delegate :subforumname, :to => :subforum, :prefix => false

  validates :subforum_id, presence: true
  validates :user_id, presence: true
  validates :postname, presence: true
  validates :content, presence: true,
            length: {minimum: 10}
            #length: {minimum: 10, message: "The 'Content' section of your post must be at least 10 characters long."}

  scope :stickied, -> { where(sticky: true) }
  scope :unstickied, -> { where(sticky: false) }

  scope :order_new_posts, -> { where("(posts.created_at > ?)",
    Time.now - 2.hours).order("posts.created_at desc") }

  scope :old_posts, -> { where("(posts.created_at < ?)",
    Time.now - 2.hours) }

  #def last_comment_user
  #  comments.last.get_user
  #end

  def self.trending
    trending_posts = Post.where("(posts.created_at > ?)",
    Time.now - 1.day).order('comments_count DESC').limit(10)
    #.(&:total_comments).first(10)
  end

  def total_comments
    comments.count
  end

  def self.order_by_comments
    posts = Post.includes(:comments).order('comments.created_at DESC')
  end

  def toggle_sticky
    sticky ? update_attribute(:sticky, false) : update_attribute(:sticky, true)
  end
  
end
