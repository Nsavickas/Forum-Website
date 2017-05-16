class PostsController < ApplicationController
  before_action :get_post_by_id, only: [:show, :edit, :update, :destroy]
  before_action :get_subforum_by_subforum_id, only: [:new, :index]
  before_action :logged_in_user, except: [:show, :index]
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :admin_user,     only: [:toggle_sticky]
  before_action :admin_only_subforum, only: [:new]
  skip_before_action :correct_user if :check_admin == true
  
  #impressionist :actions => [:show, :index]
  
  include PostsHelper
  
  def toggle_sticky
    @post = Post.find(params[:post_id])
    @subforum = @post.subforum
        
    respond_to do |format|
      if @post.toggle_sticky
        format.html { redirect_to subforum_posts_path(@subforum, @post), notice: 'Toggle sticky was successful.' }
        format.js {}
        format.json { render :index, status: :updated, location: @post }
      else
        flash[:danger] = "Toggle sticky was not successful"
      end
    end
  end
     
  def new
    @post = Post.new
  end
  
  def show
    @comments = @post.comments.page(params[:page]).per(10)
    @like = Like.new
    #impressionist(@post)
  end
  
  def index
    @subforum_posts = @subforum.posts
    @newest_posts = @subforum_posts.unstickied.order_new_posts
    @stickied_posts = @subforum_posts.stickied.order_by_comments
    @old_posts = @subforum_posts.unstickied.old_posts.order_by_comments
    
    @all_posts = @stickied_posts + @newest_posts + @old_posts
    @posts = Kaminari.paginate_array(@all_posts).page(params[:page]).per(10) 
    
    #impressionist(@post)
  end
  
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        if params[:images]
          params[:images].each do |image|
            @post.pictures.create(image: image)
          end
        end
        
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    if @post.update_attributes(post_params)
      if params[:images]
        params[:images].each do |image|
          @post.pictures.create(image: image)
        end
      end
      flash[:success] = "Post updated"
      redirect_to @post
    else
      render 'edit'
    end
  end
  
  def destroy
    subforum_id = @post.subforum_id
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to subforum_posts_url(subforum_id)
  end
  
  private
  
    def get_post_by_id 
      @post = Post.find(params[:id])
    end
  
    def get_subforum_by_subforum_id
      @subforum = Subforum.find(params[:subforum_id])
    end
    
    def post_params
        params.require(:post).permit(:postname, :content, :user_id, 
          :subforum_id, :sticky, :pictures)
    end
    
    def admin_only_subforum
      @subforum = Subforum.find(params[:subforum_id])
      if @subforum.subforumname == "Announcements"
        flash[:warning] = "You don't have the necessary privileges to post in that subforum"
        redirect_to root_url unless current_user.admin?
      end
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      redirect_to(root_url) unless current_user?(@post.user)
    end
  
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
    
    def check_admin
      current_user.admin?
    end
end
