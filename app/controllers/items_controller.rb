class ItemsController < ApplicationController
  before_action :logged_in_user, except: [:index, :show]
  before_action :admin_user, except: [:index, :show]
  
  include ItemsHelper
  
  def purchase
    
  end
  
  def new
    @item = Item.new
  end
  
  def show
    @item = Item.find(params[:id])
    @pictures = @item.pictures
  end
  
  def index
    @items = Item.filter(params.slice(:itemname, :max_price, :min_price))
  end
  
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        if params[:images]
          params[:images].each do |image|
            @item.pictures.create(image: image)
          end
        end
        
        format.html { redirect_to @item, notice: 'Item was successfully added to the online store.' }
        format.json { render :show, status: :created, location: @item}
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    if @item.update_attributes(item_params)
      if params[:images]
          params[:images].each do |image|
            @item.pictures.create(image: image)
          end
      end
      # Handle a successful update.
      flash[:success] = "Item updated"
      redirect_to @item
    else
      render 'edit'
    end
  end
  
  def destroy
    Item.find(params[:id]).destroy
    flash[:success] = "Item removed from the online store"
    redirect_to items_url
  end
  
  private
  
    def item_params
        params.require(:item).permit(:itemname, :category, :price, 
        :description, :stock, :user_id, :pictures)
    end
    
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
  
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
   
end


