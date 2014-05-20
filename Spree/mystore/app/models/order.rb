class Order < ActiveRecord::Base
	belongs_to :file_order, :foreign_key => "id_order"
	#attr_accessible :no_order
end
