class CreateSftps < ActiveRecord::Migration
  def change
    create_table :sftps do |t|

      t.timestamps
    end
  end
end
