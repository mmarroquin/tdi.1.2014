class CreateWebProducts < ActiveRecord::Migration
  def change
    create_table :web_products do |t|
      t.string :sku
      t.string :description
      t.string :price_normal
      t.string :price_internet
      t.string :category
      t.string :img
      t.string :order_id

      t.timestamps
    end
  end
end
