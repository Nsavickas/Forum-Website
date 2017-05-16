class CreateAvatars < ActiveRecord::Migration
  def change
    create_table :avatars do |t|
      t.attachment :displaypic
      t.references :user

      t.timestamps null: false
    end
    add_index :avatars, :user_id
    
  end
end
