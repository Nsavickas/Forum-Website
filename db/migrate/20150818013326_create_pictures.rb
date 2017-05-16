class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.boolean :default_image, default: false
      t.attachment :image
      t.references :imageable, polymorphic: true, index: true
      
      t.timestamps null: false
    end
  end
end
