require 'twitter'
class Tweet < ActiveRecord::Base
	def self.publish(mesage)
		client = Twitter::REST::Client.new do |config|
  			config.consumer_key        = "eRxuHhXVzj4Y0Fo2nVaiZ12KW"
  			config.consumer_secret     = "yKTF6TCOGSG95TNOLnnpieiR4D9DWsrzhRpQxpo9IkJ9P4UrWI"
  			config.access_token        = "2535794539-Fsz27LQVpJFgG78OftgZZdaSFHuHt5uKpf7Fouh"
  			config.access_token_secret = "obUdr4H1FadIIZFYrHUMVPeHYaTo3B2GcIC4cyEMCcBOw"
		end
		client.update(mesage)
	end 

end
