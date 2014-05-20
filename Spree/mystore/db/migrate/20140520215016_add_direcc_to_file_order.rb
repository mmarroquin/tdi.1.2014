class AddDireccToFileOrder < ActiveRecord::Migration
  def change
    add_column :file_orders, :direcc_id, :string
  end
end
