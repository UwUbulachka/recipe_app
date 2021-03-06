# frozen_string_literal: true

class CreateIngredients < ActiveRecord::Migration[6.1]
  def change
    create_table :ingredients do |t|
      t.string :ing, null: false
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
