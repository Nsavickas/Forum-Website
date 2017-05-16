class FriendshipsController < ApplicationController
  before_action :logged_in_user
  before_action :verify_friendship, only: :destroy
  before_action :verify_friended, only: :update
  
  def create
    @friendship = Friendship.new(friendship_params)
    respond_to do |format|
      if @friendship.save
        if @friendship.friended.notification_configuration.notify_friendships == true
          NotificationWorker.perform_async(@friendship.id, 
            "#{@friendship.class.name.demodulize}", 'Request')
        end
        
        format.js {}
        format.json { render :nothing, status: :created, location: @user }
      else
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end   
    end
  end
  
  def index
    @user = User.find(params[:user_id])
    
    @accepted_friended_friendships = Friendship.accepted.get_friended_friendships(@user)
    @accepted_friender_friendships = Friendship.accepted.get_friender_friendships(@user)
    @pending_outgoing_friendships = Friendship.pending.get_friender_friendships(@user)
    @pending_incoming_friendships = Friendship.pending.get_friended_friendships(@user)
  end
  
  def update
    @friendship = Friendship.find(params[:id])
    respond_to do |format|
      if @friendship.update_attributes(friendship_params)
        if @friendship.friender.notification_configuration.notify_friendships == true
          NotificationWorker.perform_async(@friendship.id, 
            "#{@friendship.class.name.demodulize}", 'Accept')
        end
        
        format.js {render layout: false, content_type: 'text/javascript'}
      else
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end
    end   
  end
  
  def destroy
    @friendship = Friendship.find(params[:id])
    @friended_user = @friendship.get_friend(current_user.id)
    
    respond_to do |format|
      if @friendship.destroy
        format.js {}
      else
        format.json { render json: @friendship.errors, status: :unprocessable_entity }
      end   
    end
  end
  
  private
  
    def friendship_params
        params.require(:friendship).permit(:friender_id, :friended_id, :accepted)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def verify_friendship
      @friendship = Friendship.find(params[:id])
      redirect_to(root_url) unless current_user == @friendship.friender || @friendship.friended
    end
    
    def verify_friended
      @friendship = Friendship.find(params[:id])
      redirect_to(root_url) unless current_user == @friendship.friended
    end
  
end
