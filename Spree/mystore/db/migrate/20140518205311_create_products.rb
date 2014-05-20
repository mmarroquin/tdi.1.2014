class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :sku
      t.string :price
      t.time :start_date
      t.time :final_date

      t.timestamps
    end
  end
end
