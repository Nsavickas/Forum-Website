class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :title
      t.boolean :viewed, default: false
      t.references :user
      t.references :notifiable, polymorphic: true, index: true

      t.timestamps null: false
    end
    add_index :notifications, :user_id
  end
end
