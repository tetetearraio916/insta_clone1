class RemoveImageFromPosts < ActiveRecord::Migration[5.2]
  def up
    remove_column :posts, :image, :string
    remove_column :posts, :images, :json
  end

  def down
    add_column :posts, :image, :string
    add_column :posts, :images, :json
  end
end
