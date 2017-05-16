class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :likeable, polymorphic: true, index: true
      t.references :user

      t.timestamps null: false
    end
    add_index :likes, :user_id
    
  end
end
