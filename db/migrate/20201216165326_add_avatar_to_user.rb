class AddAvatarToUser < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :avatar, :string
  end

  def down
    remove_column :users, :avatar, :string
  end
end
