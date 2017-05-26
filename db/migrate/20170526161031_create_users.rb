class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
    # adding the opetion 'unique: true' to 'add_index'
    # method in a migration enforces uniqueness on that
    # at the database level
    add_index :users, :email, unique: true
  end
end
