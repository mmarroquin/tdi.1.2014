class ChangeProductsType < ActiveRecord::Migration
  def change
  	change_column :products, :start_date, :string   	
 	change_column :products, :final_date, :string
  end
end
