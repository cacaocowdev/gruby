# This migration comes from active_storage (originally 20170806125915)
class AddUniqueConstraint < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL 
      CREATE UNIQUE INDEX ingredients_recipes_unique ON ingredients_recipes (ingredient_id,recipe_id)
    SQL
    add_index :recipes, :title, unique: true
    add_index :ingredients, :name, unique: true
  end
end
