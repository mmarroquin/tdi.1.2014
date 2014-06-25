class AddBrokedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :broked, :boolean
  end
end
