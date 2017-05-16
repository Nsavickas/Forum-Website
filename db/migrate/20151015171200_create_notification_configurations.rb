class CreateNotificationConfigurations < ActiveRecord::Migration
  def change
    create_table :notification_configurations do |t|
      t.boolean :notify_friendships, default: true
      t.boolean :notify_likes, default: true
      t.boolean :notify_comments, default: true
      t.references :user

      t.timestamps null: false
    end
    add_index :notification_configurations, :user_id
  end
end
