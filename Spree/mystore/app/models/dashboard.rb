class Dashboard < ActiveRecord::Base
	require 'googlecharts'

	def self.plot
		grafico = Gchart.pie_3d(:title => "Joseto el peors",
			:labels => ["Despachado", "Quebrado", "Pulentoso"],
			:data => [10,30,100],
			:size => '400x200')
		return grafico
	end

end
