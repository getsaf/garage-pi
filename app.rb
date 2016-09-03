require 'sinatra'
require 'sinatra/json'
require_relative 'models/garage.rb'
require_relative 'models/door.rb'
require_relative 'models/user.rb'
require_relative 'models/app_config.rb'

class Application < Sinatra::Base
	set :port, AppConfig.port
	set :bind, '0.0.0.0'

	configure do
		@@users = AppConfig.users
		@@garage = AppConfig.garage
		puts @@garage.name
		@@garage.doors.each do |door|
			puts "- #{door.name}: s:#{door.sensor_pin}, t: #{door.trigger_pin}"
		end
	end

	use Rack::Auth::Basic, "Restricted Area" do |username, password|
		return true if @@users.empty?
		@@users.select do |user|
			username == user.username && password == user.password
		end
	end

	get '/' do
		puts "@@garage = #{@@garage}"
		haml :index, locals: { garage: @@garage }
	end

	get '/garage' do
		json garage_hash
	end

	post '/toggle' do
		@@garage[params[:name]].toggle
		json garage_hash
	end

	private

	def garage_hash
		doors = @@garage.doors.map do |door|
			{ name: door.name, status: door.status }
		end
		{ name: @@garage.name, doors: doors }
	end

	run! if app_file == $0
end

