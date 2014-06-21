class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.string :sku
      t.string :precio
      t.date :inicio
      t.date :fin
      t.boolean :fuePublicado

      t.timestamps
    end
  end
end
