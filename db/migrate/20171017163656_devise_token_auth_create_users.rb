class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table(:users) do |t|
      t.string :provider, null: false, default: 'name'
      t.string :uid, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## User Info
      t.string :name

      t.json :tokens

      t.timestamps
    end

    add_index :users, :name, unique: true
    add_index :users, %i[uid provider], unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
