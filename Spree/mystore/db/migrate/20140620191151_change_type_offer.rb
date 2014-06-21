class ChangeTypeOffer < ActiveRecord::Migration
  def change
  	change_column :offers, :inicio, :datetime
	change_column :offers, :fin, :datetime
  end
end
