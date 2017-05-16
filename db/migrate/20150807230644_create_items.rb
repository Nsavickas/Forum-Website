class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :itemname
      t.string :category
      t.float :price
      t.text :description
      t.integer :stock
      t.references :user

      t.timestamps null: false
    end
    
    add_index :items, :user_id
  end
end
