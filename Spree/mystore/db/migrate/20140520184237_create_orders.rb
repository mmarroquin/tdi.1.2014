class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :id_order
      t.string :sku_order
      t.string :quantity
      t.boolean :delivered

      t.timestamps
    end
  end
end
