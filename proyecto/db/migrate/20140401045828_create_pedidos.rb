class CreatePedidos < ActiveRecord::Migration
  def change
    create_table :pedidos do |t|
      t.string   :nombrecliente
      t.string   :address
      t.integer  :state
      t.float    :latitude  
      t.float  	 :longitude
      t.timestamps
    end
  end
end
