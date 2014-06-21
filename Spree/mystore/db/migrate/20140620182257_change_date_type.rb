class ChangeDateType < ActiveRecord::Migration
  def change
	change_column :offers, :inicio, :time
	change_column :offers, :fin, :time
  end
end
