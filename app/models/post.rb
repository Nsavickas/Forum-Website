class Post < ActiveRecord::Base
  #include Impressionist::IsImpressionable
  #is_impressionable :counter_cache => true, :column_name => :views_count, :unique => true

  belongs_to :user
  belongs_to :subforum
  has_many :comments, :dependent => :destroy
  has_many :pictures, as: :imageable, :dependent => :destroy
  has_many :likes, as: :likeable, :dependent => :destroy

  validates :subforum_id, presence: true
  validates :user_id, presence: true
  validates :postname, presence: true
  validates :content, presence: true,
            length: {minimum: 10}
            #length: {minimum: 10, message: "The 'Content' section of your post must be at least 10 characters long."}


  ############### SCOPES ##################


  scope :stickied, -> { where(sticky: true) }
  scope :unstickied, -> { where(sticky: false) }

  scope :order_new_posts, -> { where("(posts.created_at > ?)",
    Time.now - 2.hours).order("posts.created_at desc") }

  scope :old_posts, -> { where("(posts.created_at < ?)",
    Time.now - 2.hours) }


  ############# INSTANCE METHODS ################


  def getTrendingRating
    recentComments = Comment.where("created_at > ? and post_id === ?", Time.now - 1.day, id).count
    recentLikes = Like.where("created_at > ? and likeable_id === ?", Time.now - 1.day, id).count
    return (2*recentComments) + (1.5*recentLikes)
  end

  def countComments
    return total_comments
  end

  def total_comments
    comments.count
  end

  def toggle_sticky
    sticky ? update_attribute(:sticky, false) : update_attribute(:sticky, true)
  end

  ############# CLASS METHODS ################

  def self.getTrendingPosts(forum_id)
    subforums = Subforum.where('forum_id === ?', forum_id)
    return Post.where('subforum_id === ?', subforums).order('posts.getTrendingPosts').limit(10)
  end

  def self.getImportantPosts(forum_id)
    subforums = Subforum.where('forum_id === ? and admin_only === ?', forum_id, true)
    return Post.where('subforum_id === ?', subforums).order('created_at DESC').limit(10)
  end

  def self.order_by_comments
    posts = Post.includes(:comments).order('comments.created_at DESC')
  end

  def self.trending
    trending_posts = Post.where("(posts.created_at > ?)", Time.now - 1.day).order('comments_count DESC').limit(10)
    #.(&:total_comments).first(10)
  end


end
