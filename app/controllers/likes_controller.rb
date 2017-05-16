class LikesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]
  before_action :correct_user, only: :destory
  
  include LikesHelper
  
  def create
    @like = Like.new(like_params)
    
    respond_to do |format|
      if @like.save 
        @liked_media = @like.get_liked_media
        if @liked_media && @liked_media.user.notification_configuration.notify_likes == true
          NotificationWorker.perform_async(@like.id, "#{@like.class.name.demodulize}", 
          "#{@liked_media.class.name.demodulize}")
        end
        format.js {}
        format.json { render :nothing, status: :created, location: @post }
      else
        format.json { render json: @like.errors, status: :unprocessable_entity }
      end   
    end
  end
  
  def destroy
    @like = Like.find(params[:id])
    @like_id = @like.likeable_id
    @like_type = @like.likeable_type
    respond_to do |format|
      if @like.destroy
        format.js {}
        format.json { render :nothing, status: :created, location: @post }
      else
        flash[:danger] = "Could not be unliked"
      end   
    end
  end
  
  
  private
  
    def like_params
        params.require(:like).permit(:likeable_id, :likeable_type, :user_id)
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      @post = Post.find(params[:id])
      redirect_to(root_url) unless current_user == @post.user
    end
end
