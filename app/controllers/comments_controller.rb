class CommentsController < ApplicationController
  before_action :get_comment, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :get_post,       only: [:index, :new]
  skip_before_action :correct_user if :check_admin == true
     
  def new
    @comment = Comment.new
  end
  
  def show
  end
  
  def index
    @comments = Comment.paginate(page: params[:page])
  end
  
  def create
    @comment = Comment.new(comment_params)
    
    respond_to do |format|
      if @comment.save
        if @comment.post.user.notification_configuration.notify_comments == true
          NotificationWorker.perform_async(@comment.id, "#{@comment.class.name.demodulize}", "Post")
        end
        
        flash[:success] = 'Comment was successfully created.'
        format.html { redirect_to @comment.post}
        format.json { render :show, status: :created, location: @comment.post }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @comment.update_attributes(comment_params)
      # Handle a successful update.
      flash[:success] = "Comment updated"
      redirect_to @comment.post
    else
      render 'edit'
    end
  end
  
  def destroy
    post = @comment.post
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to post
  end
  
  
  private
  
    def get_comment
      @comment = Comment.find(params[:id])
    end
    
    def get_post
      @post = Post.find(params[:post_id])
    end
    
    def comment_params
        params.require(:comment).permit(:comment_content, :post_id, :user_id)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      redirect_to(root_url) unless current_user == @comment.user
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def check_admin
      current_user.admin?
    end
end
