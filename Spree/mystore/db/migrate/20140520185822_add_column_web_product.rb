class AddColumnWebProduct < ActiveRecord::Migration
  def change
  	add_column :web_products, :brand, :string
  	add_column :web_products, :model, :string
  end
end
