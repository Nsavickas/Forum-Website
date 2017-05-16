class PicturesController < ApplicationController
  before_action :admin_user, except: [:create, :destroy]
  before_action :correct_user, only: [:destory]
  before_action :logged_in_user
  
  def index
    @user = User.find(params[:user_id])
    @pictures = @user.pictures
  end
  
  def create
    @picture = Picture.new(picture_params)

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, notice: 'Picture was successfully created' }
        format.json { render :show, status: :created, location: @picture}
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @picture = Picture.find(params[:id])
  end
  
  def update
    @picture = Picture.find(params[:id])
    if @picture.update_attributes(picture_params)
      flash[:success] = "Picture updated"
      redirect_to pictures_url
    else
      render 'edit'
    end
  end
  
  def destroy
    Picture.find(params[:id]).destroy
    flash[:success] = "Picture removed"
    redirect_to :back
  end
  
  private
  
    def picture_params
        params.require(:picture).permit(:image, :imageable_id, :imageable_type, :default_image)
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
