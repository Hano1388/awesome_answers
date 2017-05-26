class AddCategoriesToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_reference :questions, :category, foreign_key: true, index: true
  end
end
