require 'rpi_gpio'

class Door
	attr_reader :name, :trigger_pin, :sensor_pin, :toggle_duration, :last_toggle, :invert_sensor

	def initialize(options)
		options = { invert_sensor: false, toggle_duration: 5 }.merge(options)
		puts "Setting up door #{options[:name]} on sensor pin #{options[:sensor_pin]}, trigger pin #{options[:trigger_pin]}"
		@name = options[:name]
		@toggle_duration = options[:toggle_duration]
		@invert_sensor = options[:invert_sensor]
		@sensor_pin = options[:sensor_pin]
		@trigger_pin = options[:trigger_pin]

		# Setup the GPIO Pins
		RPi::GPIO.set_numbering :bcm
		RPi::GPIO.setup sensor_pin, as: :input, pull: :up
		RPi::GPIO.setup trigger_pin, as: :output
		RPi::GPIO.set_high trigger_pin
	end

	def open
		toggle unless open? || opening?
	end

	def close
		toggle unless closed? || closing?
	end

	def toggle
		@toggle_status = open? ? :closing : :opening
		puts @toggle_status
		@last_toggle = Time.now
		RPi::GPIO.set_low trigger_pin
		sleep 0.2
		RPi::GPIO.set_high trigger_pin
	end

	def open?
		invert_sensor ? RPi::GPIO.low?(sensor_pin) : RPi::GPIO.high?(sensor_pin)
	end

	def closed?
		!open?
	end

	def opening?
		@toggle_status == :opening && !toggling?
	end

	def closing?
		@toggle_status == :closing && !toggling?
	end

	def status
		[:opening?, :closing?, :open?, :closed?].each do |status|
			return status.to_s[0...-1] if send(status)
		end
	end

	private

	def toggling?
		@last_toggle && (Time.now - @last_toggle) >= @toggle_duration
	end
end
