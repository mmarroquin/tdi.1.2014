class Dashboard < ActiveRecord::Base
	require 'googlecharts'

	def self.plot
		grafico = Gchart.pie_3d(:title => "Joseto el mejors",
			:labels => ["Despachado", "Quebrado", "Pulentoso"],
			:data => [10,30,100],
			:size => '400x200')
		return grafico
	end

	def self.info
		grafico = Gchart.pie_3d(:title => "Fancy title",
			:labels => ["Fancy entry", "Fancy entry2", "Whatever"],
			:data => [200,350,100],
			:size => '400x200')
		return grafico
	end

	def self.plot_reservations
		total_date = Reservation.count

		grafico = Gchart.pie_3d(:title => "Fancy title",
			:labels => ["Fancy entry", "Fancy entry2", "Whatever"],
			:data => [200,350,100],
			:size => '400x200')
		return grafico
	end	

	def self.plot_bar
		grafico = Gchart.bar( :data => [[1,2,4,67,100,41,234],[45,23,67,12,67,300, 250]], 
            :title => 'SD Ruby Fu level', 
            :legend => ['matt','patrick'], 
            :bg => {:color => '76A4FB', :type => 'gradient'}, 
            :bar_colors => 'ff0000,00ff00')
		return grafico
	end

end
