class UsersController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,   only: [:edit, :update, :destroy]
  before_action :admin_user,     only: :destroy
  before_action :get_user, only: [:show, :edit, :update, :destroy]
  
  def new
    @user = User.new
  end
  
  def show
    @avatar = @user.avatar
    @friendship = Friendship.get_mutual_friendship(@user.id, current_user.id).first
    @user_posts = @user.posts.page(params[:page]).per(10)
    @user_comments = @user.comments.page(params[:page]).per(10)
    @user_likes = @user.likes.page(params[:page]).per(10)
  end
  
  def index
    @users = User.search(params[:search])
    if params[:search]
      @users = Kaminari.paginate_array(@users).page(params[:page]).per(10) 
    else 
      @users = User.order(:name).page params[:page]
    end
  end
  
  def create
    @user = User.new(user_params)   
    
    respond_to do |format|
      if @user.save
        if params[:images]
          params[:images].each do |image|
            @user.pictures.create(image: image)
          end
        end
        
        @user.notification_configuration.create(user_id: @user.id)
        
        @user.send_activation_email
        
        format.html { redirect_to @user, notice: 'Please check your email to activate your account' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end  
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      if params[:images]
          params[:images].each do |image|
            @user.pictures.create(image: image)
          end
      end
      
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :pictures)
    end
    
    def get_user
      @user = User.find(params[:id])
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
end
