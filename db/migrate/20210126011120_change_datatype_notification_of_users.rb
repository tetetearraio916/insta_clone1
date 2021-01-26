class ChangeDatatypeNotificationOfUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :notification_on_comment, :integer
    change_column :users, :notification_on_like, :integer
    change_column :users, :notification_on_follow, :integer
  end
end
