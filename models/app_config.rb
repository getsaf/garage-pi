require 'json'

class AppConfig
	class << self
		def port
			@port ||= json[:port] || 8080
		end

		def users
			@users ||= (json[:users] || []).map {|user| User.new(user)}
		end

		def garage
			return @garage if @garage
			garage = json[:garage]
			doors = garage[:doors].map {|door| Door.new(door)}

			@garage = Garage.new(garage[:name], doors)
		end

		private

		def json
			@json ||= JSON.parse(File.read('config.json'), symbolize_names: true)
		end
	end
end
