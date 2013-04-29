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
		attribute :pw
		unique :name
		index :name

		def validate
			assert_present :name
			assert_present :pw
		end
	end
end
