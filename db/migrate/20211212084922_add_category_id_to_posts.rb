# frozen_string_literal: true

class AddCategoryIdToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :category_id, :integer
    add_index :posts, :category_id
  end
end
