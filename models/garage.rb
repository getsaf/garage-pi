class Garage
	attr_reader :name, :doors, :users
	def initialize(name, doors, users = [])
		@name = name
		@doors = doors
		@users = users
	end
	
	def [](door_name)
		@doors.select {|door| door.name == door_name}.first
	end
end
