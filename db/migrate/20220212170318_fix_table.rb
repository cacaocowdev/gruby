class FixTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :recipes_ingredients

    create_join_table :recipes, :ingredients do |t|
      t.index :recipe_id
      t.index :ingredient_id
    end
  end
end
