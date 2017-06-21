class StaticPagesController < ApplicationController
  before_action :admin_user, only: [:admin]

  def home
  end

  def planetside2
    @forum = Forum.find_by(forumname: 'Planetside 2')
    @trending_posts = Post.getTrendingPosts(@forum.id)
    @important_posts = Post.getImportantPosts(@forum.id)
  end

  def nazizombies
    @forum = Forum.find_by(forumname: 'Nazi Zombies')
    @trending_posts = Post.getTrendingPosts(@forum.id)
    @important_posts = Post.getImportantPosts(@forum.id)
  end

  def about
  end

  def contact
  end

  def admin
  end

  private

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
