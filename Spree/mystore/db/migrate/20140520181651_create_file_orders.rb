class CreateFileOrders < ActiveRecord::Migration
  def change
    create_table :file_orders do |t|
      t.datetime :orderDate
      t.date :deliveryDate
      t.integer :quantity
      t.string :no_order
      t.string :rut
      t.string :direcc_id
      t.boolean :processed
      t.boolean :delivered
      t.boolean :success

      t.timestamps
    end
  end
end
