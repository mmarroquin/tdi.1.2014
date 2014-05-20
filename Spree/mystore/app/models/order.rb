class Order < ActiveRecord::Base
	has_many :web_products
end
