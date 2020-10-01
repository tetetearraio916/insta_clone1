class RemoveUserFromImage < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :images, :users
    remove_index :images, :user_id
    remove_reference :images, :user
  end
end
