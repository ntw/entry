require 'redis'
require 'ohm'

module Entry
	class GateKeeper
		def initialize(options = {})
			Ohm.connect(options)
		end
	end

	class User < Ohm::Model
		attribute :name
		unique :name

		def validate
			assert_present :name
		end
	end
end
