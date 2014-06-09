class CreateRabbitmpqs < ActiveRecord::Migration
  def change
    create_table :rabbitmpqs do |t|

      t.timestamps
    end
  end
end
