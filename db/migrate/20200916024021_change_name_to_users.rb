class ChangeNameToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column_null :users, :name, null: false
  end
end
