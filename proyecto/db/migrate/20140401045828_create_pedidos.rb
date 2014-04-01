class CreatePedidos < ActiveRecord::Migration
  def change
    create_table :pedidos do |t|
      t.datetime :date

      t.timestamps
    end
  end
end
