class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.string :category, :null => false
      t.string :use, :null => false
      t.integer :amount, :null => false
      t.boolean :income, :default => false
      t.date :date, :null => false

      t.timestamps
    end
  end
end
