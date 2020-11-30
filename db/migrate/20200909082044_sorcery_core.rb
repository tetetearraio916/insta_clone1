class SorceryCore < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name,            null: false
      t.string :email,            null: false
      t.string :crypted_password
      t.string :salt
      #画像ファイル名用のカラム
      t.string :avatar

      t.timestamps                null: false
    end

    add_index :users, :email, unique: true
  end
end
