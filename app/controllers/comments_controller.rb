class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  skip_before_action :correct_user if :check_admin


  def new
    @comment = Comment.new
    #@post = Post.find(params[:post_id])
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def index
    @comments = Comment.paginate(page: params[:page])
    @post = Post.find(params[:post_id])
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
    @comment = Comment.find(params[:id])
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(comment_params)
      flash[:success] = "Comment Updated!"
      redirect_to @comment.post
    else
      render 'edit'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    post = @comment.post
    @comment.destroy
    flash[:success] = "Comment Deleted!"
    redirect_to post
  end

  private

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
      return current_user.admin?
    end
end
