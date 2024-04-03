class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.integer :stock
      t.decimal :price
      t.string :state
      t.timestamp :delete_at

      t.timestamps
    end
  end
end
