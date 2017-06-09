class AddAdminOnlyToSubforum < ActiveRecord::Migration
  def change
    add_column :subforums, :admin_only, :boolean, default: false
  end
end
