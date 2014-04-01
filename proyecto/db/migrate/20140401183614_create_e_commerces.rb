class CreateECommerces < ActiveRecord::Migration
  def change
    create_table :e_commerces do |t|

      t.timestamps
    end
  end
end
