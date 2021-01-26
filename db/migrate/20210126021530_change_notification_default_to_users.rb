class ChangeNotificationDefaultToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_default :users, :notification_on_comment, from: 0, to: 1
    change_column_default :users, :notification_on_like, from: 0, to: 1
    change_column_default :users, :notification_on_follow, from: 0, to: 1
  end
end
