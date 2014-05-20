class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :n_pedido
      t.string :despachado
      t.string :quiebre
      t.string :fecha

      t.timestamps
    end
  end
end
