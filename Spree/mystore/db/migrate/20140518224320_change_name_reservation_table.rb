class ChangeNameReservationTable < ActiveRecord::Migration
  def change
    rename_table :product_reservations, :reservations
  end
end
