class Garage
	attr_reader :name, :doors
	def initialize(name, doors)
		@name = name
		@doors = doors
	end
	
	def [](door_name)
		@doors.select {|door| door.name.casecmp(door_name) === 0}.first
	end
end
