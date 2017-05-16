class ForumsController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user
  before_action :get_forum, only: [:show, :edit, :update]
       
  def new
    @forum = Forum.new
  end
  
  def show
  end
  
  def index
    @forums = Forum.all
  end
  
  def create
    @forum = Forum.new(forum_params)

    respond_to do |format|
      if @forum.save
        format.html { redirect_to @forum, notice: 'Forum was successfully created.' }
        format.json { render :show, status: :created, location: @forum }
      else
        format.html { render :new }
        format.json { render json: @forum.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
  end
  
  def update
    if @forum.update_attributes(forum_params)
      # Handle a successful update.
      flash[:success] = "Forum updated"
      redirect_to @forum
    else
      render 'edit'
    end
  end
  
  def destroy
    Forum.find(params[:id]).destroy
    flash[:success] = "Forum deleted"
    redirect_to forums_url
  end
  
  private
  
    def forum_params
      params.require(:forum).permit(:forumname)
    end
    
    def get_forum
      @forum = Forum.find(params[:id])
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
