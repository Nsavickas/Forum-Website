class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :postname
      t.text :content
      t.references :user
      t.references :subforum

      t.timestamps null: false
    end
    
    add_index :posts, :user_id
    add_index :posts, :subforum_id
    
  end
end
