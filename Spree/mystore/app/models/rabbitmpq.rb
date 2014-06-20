require 'json'
require 'bunny'
class Rabbitmpq < ActiveRecord::Base

	def self.connect
		@b = Bunny.new('amqp://fvpieoya:4IP2zWMn8c29fFyxfFG-0Vro5LRVwFKf@tiger.cloudamqp.com/fvpieoya')
		@b.start
	end

	def self.disconnect
		@b.stop
	end
	
	def self.readReposicion
		conn = Bunny.new('amqp://fvpieoya:4IP2zWMn8c29fFyxfFG-0Vro5LRVwFKf@tiger.cloudamqp.com/fvpieoya')
		conn.start

		ch = conn.create_channel
		q = ch.queue("reposicion",:auto_delete=>true)
		content1 = q.pop
		puts content1

	end

	def self.leerOferta
		conn = Bunny.new('amqp://fvpieoya:4IP2zWMn8c29fFyxfFG-0Vro5LRVwFKf@tiger.cloudamqp.com/fvpieoya')
		conn.start

		ch = conn.create_channel
		q = ch.queue("ofertas",:auto_delete=>true)
		while q.message_count>100
			content1 = q.pop do |delivery_info, properties, body|
				puts body
				oferta = JSON.parse(body)
				Offer.create(:sku=>oferta['sku'], :precio=>oferta['precio'], :inicio=>Time.at(oferta["inicio"]/1000), :fin=>Time.at(oferta["fin"]/1000))
			end
		end
	end

end
