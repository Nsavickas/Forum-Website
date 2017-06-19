class StaticPagesController < ApplicationController
  before_action :admin_user, only: [:admin]

  def home
  end

  def planetside2
    @forum = Forum.find_by(forumname: 'Planetside 2')
    #@posts = @subforum ? @subforum.posts : nil
    @trending_posts = Post.trending
  end

  def nazizombies
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
