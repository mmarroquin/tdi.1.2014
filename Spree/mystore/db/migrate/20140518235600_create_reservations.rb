class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :sku
      t.date :date
      t.string :client
      t.integer :amount
      t.boolean :used

      t.timestamps
    end
  end
end
