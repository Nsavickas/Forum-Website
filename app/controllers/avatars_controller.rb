class AvatarsController < ApplicationController
  before_action :logged_in_user, only: [:new, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy, :sticky]
  before_action :get_user, only: [:new, :index]
     
  def new
    @avatar = Avatar.new
  end
  
  def show
    @avatar = Avatar.find(params[:id])
  end
  
  def index
    @avatars = Avatar.paginate(page: params[:page])
  end
  
  def create
    @avatar = Avatar.new(avatar_params)

    respond_to do |format|
      if @avatar.save
        
        format.html { redirect_to @avatar.user, notice: 'Avatar was successfully created.' }
        format.json { render :show, status: :created, location: @avatar.user }
      else
        format.html { render :new }
        format.json { render json: @avatar.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @avatar = Avatar.find(params[:id])
  end
  
  def update
    @avatar = Avatar.find(params[:id])
    if @avatar.update_attributes(avatar_params)
      flash[:success] = "Avatar updated"
      redirect_to @avatar.user
    else
      render 'edit'
    end
  end
  
  def destroy
    Avatar.find(params[:id]).destroy
    flash[:success] = "Avatar deleted"
    redirect_to :back
  end
  
  private
  
    def get_user
      @user = User.find(params[:user_id])
    end
    
    def avatar_params
        params.require(:avatar).permit(:displaypic, :user_id)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      @avatar = Avatar.find(params[:id])
      redirect_to(root_url) unless current_user == @avatar.user
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
