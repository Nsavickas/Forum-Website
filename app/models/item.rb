class Item < ActiveRecord::Base
  include Filterable
  
  belongs_to :user
  has_many :pictures, as: :imageable, :dependent => :destroy
  
  paginates_per 10
  
  validates :itemname, presence: true,
            length: {minimum: 3} 
  validates :category, presence: true
  validates :price, presence: true,
            :numericality => { :greater_than_or_equal_to => 0 }
  validates :stock, presence: true,
            :numericality => { :greater_than_or_equal_to => 0 }
  validates :user_id, presence: true
 
  scope :food, -> {where(category: 'Food')}
  scope :vehicles, -> {where(category: 'Vehicles')}
  scope :clothing, -> {where(category: 'Clothing')}
  scope :luxury, -> {where(category: 'Luxury')}
  
  scope :itemname, -> (itemname) { where("itemname LIKE ?", "%#{itemname}%")}
  scope :max_price, -> (max_price) { where("price <= ?", "#{max_price}%")}
  scope :min_price, -> (min_price) { where("price >= ?", "#{min_price}%")}
  
  #searchable do 
  #  text :itemname
  #  string :category
    #float :price_high
    #float :price_low
  #  float :price
  #end
end
