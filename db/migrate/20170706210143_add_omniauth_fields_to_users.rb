class AddOmniauthFieldsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :oath_token, :string
    add_column :users, :oath_secret, :string
    add_column :users, :oath_raw_data, :text
    add_index :users, [:uid, :provider]
  end
end
