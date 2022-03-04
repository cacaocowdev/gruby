class CreateIngredients < ActiveRecord::Migration[7.0]
  def change
    create_table :ingredients do |t|
      t.string :name

      t.timestamps
    end

    create_table :recipes_ingredients, id: false do |t|
      t.belongs_to :recipe
      t.belongs_to :ingredient
    end
  end
end
