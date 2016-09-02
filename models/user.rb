class User
	attr_reader :username, :password
	def initialize(options)
		@username = options[:username]	
		@password = options[:password]	
	end
end
