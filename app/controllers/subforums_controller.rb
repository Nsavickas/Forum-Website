class SubforumsController < ApplicationController
  before_action :logged_in_user,  except: [:index]
  before_action :admin_user,      only: [:new, :edit, :destroy, :create, :update]
  before_filter :get_forum,       only: [:new, :index]

  def new
    @subforum = Subforum.new
  end

  def show
    @subforum = Subforum.find(params[:id])
  end

  def index
    @subforums = @forum.subforums.order(:subforumname).page params[:page]
  end

  def create
    @subforum = Subforum.new(subforum_params)

    respond_to do |format|
      if @subforum.save
        format.html { redirect_to @subforum, notice: 'Discussion Created!' }
        format.json { render :show, status: :created, location: @subforum }
      else
        format.html { render :new }
        format.json { render json: @subforum.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @subforum = Subforum.find(params[:id])
  end

  def update
    @subforum = Subforum.find(params[:id])
    if @subforum.update_attributes(subforum_params)
      flash[:success] = "Update Successful!"
      redirect_to @subforum
    else
      render 'edit'
    end
  end

  def destroy
    Subforum.find(params[:id]).destroy
    flash[:success] = "Subforum deleted"
    redirect_to :back
  end

  private

    def get_forum
      @forum = Forum.find(params[:forum_id])
    end

    def subforum_params
        params.require(:subforum).permit(:subforumname, :admin_only , :forum_id)
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
