class CreateSubforums < ActiveRecord::Migration
  def change
    create_table :subforums do |t|
      t.string :subforumname
      t.references :forum
      t.timestamps null: false
    end
    
    add_index :subforums, :forum_id
  end
end
