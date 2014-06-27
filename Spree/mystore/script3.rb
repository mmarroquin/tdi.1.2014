require 'rest_client'
require 'uri'
require 'json'
require 'rufus-scheduler'


puts "Start"
	scheduler = Rufus::Scheduler.new
	scheduler.every '1s' do
	puts 'Hello... Rufus'
	runner "/home/administrator/commandsapp/app/script.rb"
	end
puts "End"
