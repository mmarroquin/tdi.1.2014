class CreateGdocs < ActiveRecord::Migration
  def change
    create_table :gdocs do |t|

      t.timestamps
    end
  end
end
