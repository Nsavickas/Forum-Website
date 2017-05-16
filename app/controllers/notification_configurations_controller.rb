class NotificationConfigurationsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update]
  
  def create
    @notification_configuration = NotificationConfiguration.new(notification_configuration_params)
    respond_to do |format|
      if @notification_configuration.save
        format.js {}
        format.json { render :nothing, status: :created, location: @notification_configuration }
      else
        format.json { render json: @notification_configuration.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @notification_configuration = NotificationConfiguration.find(params[:id])
  end
  
  def update
    @notification_configuration = NotificationConfiguration.find(params[:id])
    respond_to do |format|
      if @notification_configuration.update_attributes(notification_configuration_params)
        format.html { redirect_to @notification_configuration.user}
        flash[:success] = "Notification settings were successfully updated." 
        format.json { render :show, status: :created, location: @notification_configuration }
      else
        format.html { render :edit}
        format.json { render json: @notification_configuration.errors, status: :unprocessable_entity }
      end
    end   
  end
  
  private 
  
    def notification_configuration_params
      params.require(:notification_configuration).permit(:notify_friendships, :notify_likes, :notify_comments, :user_id)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      @notification_configuration = NotificationConfiguration.find(params[:id])
      redirect_to(root_url) unless current_user == @notification_configuration.user
    end
  
end
