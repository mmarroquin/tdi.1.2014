class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :n_pedido
      t.string :rut

      t.timestamps
    end
  end
end
