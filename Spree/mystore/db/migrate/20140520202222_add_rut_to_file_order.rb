class AddRutToFileOrder < ActiveRecord::Migration
  def change
    add_column :file_orders, :rut, :string
  end
end
