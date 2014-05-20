class Product < ActiveRecord::Base

	def self.readcsv
		@errors = []
	    filename = '/home/administrator/commandsapp/llamarRuby/outputJava.csv'
	    file = File.new(filename, 'r')
	    file.each_line("\n") do |row|
	      columns = row.split(',')
	      begin
	        aux = Product.where(:sku=>columns[1], :price=>columns[2], :start_date=>columns[3], :final_date=>columns[4]).first
	        if aux == nil
	          Product.create(:sku=>columns[1], :price=>columns[2], :start_date=>columns[3], :final_date=>columns[4])
	        end
	      rescue Exception => e
	        @errors << columns
	      end
	    end
	end
end
