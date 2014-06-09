class Rabbitmpq < ActiveRecord::Base

	require 'bunny'
	
	def self.read_msg

		#@b = Bunny.new('amqp://fvpieoya:4IP2zWMn8c29fFyxfFG-0Vro5LRVwFKf@tiger.cloudamqp.com/fvpieoya')
		#b.start # start a communication session with the amqp server

		#q = @b.queue("test1") # declare a queue

		# declare default direct exchange which is bound to all queues
		#e = @b.exchange("")

		# publish a message to the exchange which then gets routed to the queue
		#e.publish("Hello, everybody!", :key => 'test1')

		msg = q.pop # get message from the queue

		puts msg

		 # close the connection
	end

	def self.connect
		@b = Bunny.new('amqp://fvpieoya:4IP2zWMn8c29fFyxfFG-0Vro5LRVwFKf@tiger.cloudamqp.com/fvpieoya')
		@b.start
	end

	def self.disconnect
		@b.stop
	end


end
