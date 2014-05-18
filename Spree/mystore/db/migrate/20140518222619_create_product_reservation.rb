class CreateProductReservation < ActiveRecord::Migration
  def change
    create_table :product_reservations do |t|
    	t.string :sku
     	t.string :client
    	t.date :date
    	t.integer :amount
    	t.boolean :used
    end
  end
end
