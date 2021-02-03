class AddNotificationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :notification_on_comment, :boolean, default:false
    add_column :users, :notification_on_like, :boolean, default:false
    add_column :users, :notification_on_follow, :boolean, default:false
  end
end
