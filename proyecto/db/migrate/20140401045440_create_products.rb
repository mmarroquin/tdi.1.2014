class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :password
      t.string :description
      t.integer :stock
      t.float :price
      t.string :sku

      t.timestamps
    end
  end
end
