class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :sku
      t.string :precio
      t.date :inicio
      t.date :fin

      t.timestamps
    end
  end
end
