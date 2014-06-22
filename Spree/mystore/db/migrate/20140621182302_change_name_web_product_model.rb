class ChangeNameWebProductModel < ActiveRecord::Migration
  def change
  	rename_column :web_products, :model, :name
  end
end
