class AddColumnOffer < ActiveRecord::Migration
  def change
  	add_column :offers, :precioBase, :string
  	add_column :offers, :TienePrecioBase, :boolean
  end
end
