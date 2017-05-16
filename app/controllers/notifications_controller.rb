class NotificationsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:index, :destory]
  
  def create
    @notification = Notification.new(notification_params)
    respond_to do |format|
      if @notification.save
        format.json { render :nothing, status: :created, location: @notification }
      else
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end   
    end
  end
  
  def index
    @user = User.find(params[:user_id])

    @viewed_notifications = @user.notifications.viewed.order(created_at: 'desc')
    @unviewed_notifications = @user.notifications.unviewed.order(created_at: 'desc')
    @all_notifications = @unviewed_notifications + @viewed_notifications
    
    @notifications = Kaminari.paginate_array(@all_notifications).page(params[:page]).per(10) 
  end
  
  def update
    @notification = Notification.find(params[:id])

    respond_to do |format|
      if @notification.update_attributes(notification_params)
        format.js {}
        format.json { render :nothing, status: :created, location: @notification }
      else
        format.json { render :nothing, status: :created, location: @notification }
      end
    end
  end
  
  def destroy
    @notification = Notification.find(params[:id])
    @notification_id = @notification.id
    respond_to do |format|
      if @notification.destroy
        format.js {}
        format.json { render :nothing, status: :created, location: @notification }
      else
        flash[:danger] = "Could not be unliked"
        format.json { render json: @notification.errors, status: :unprocessable_entity }
      end   
    end
  end
  
  private
  
    def notification_params
      params.require(:notification).permit(:title, :viewed, :user_id, :notifiable_id, :notifiable_type)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:user_id])
      redirect_to(root_url) unless current_user == @user
    end
end
