class ChangeNotificationDefaultToUsers < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :notification_on_comment, :boolean, default: true
    change_column :users, :notification_on_like, :boolean, default: true
    change_column :users, :notification_on_follow, :boolean, default: true
  end

  def down
    change_column :users, :notification_on_comment,:boolean, default: false
    change_column :users, :notification_on_like,:boolean, default: false
    change_column :users, :notification_on_follow,:boolean, default: false
  end
end
