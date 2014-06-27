class CreateReposicions < ActiveRecord::Migration
  def change
    create_table :reposicions do |t|
      t.string :sku
      t.datetime :fecha
      t.string :almacenId
      t.boolean :fueRepuesto

      t.timestamps
    end
  end
end
