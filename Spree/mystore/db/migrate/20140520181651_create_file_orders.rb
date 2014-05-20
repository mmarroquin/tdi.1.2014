class CreateFileOrders < ActiveRecord::Migration
  def change
    create_table :file_orders do |t|
      t.string :no_order
      t.string :date

      t.timestamps
    end
  end
end
