require 'json'

class AppConfig
	class << self
		def garage
			json = JSON.parse(File.read('config.json'), symbolize_names: true)
			garage = json[:garage]
			doors = garage[:doors].map {|door| Door.new(door)}
			users = (garage[:users] || []).map {|user| User.new(user)}

			Garage.new(garage[:name], doors, users)
		end
	end
end
