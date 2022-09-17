class CreateTodos < ActiveRecord::Migration[7.0]
  def change
    create_table :todos do |t|
      t.string :title
      t.text :body
      t.datetime :due
      t.boolean :done

      t.timestamps
    end
  end
end
