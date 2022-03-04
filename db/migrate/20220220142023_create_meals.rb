class CreateMeals < ActiveRecord::Migration[7.0]
  def change
    create_table :meals do |t|
      t.belongs_to :recipe, foreign_key: true
      t.date :day

      t.timestamps
    end
  end
end
