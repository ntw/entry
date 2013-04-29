require 'redis'
require 'ohm'

module Entry
	class GateKeeper
		def initialize(options = {})
			Ohm.connect(options)
		end
	end

	class Auth < Ohm::Model
	end

	class User < Ohm::Model
		attribute :name
		attribute :pw
		list :auths, Auth
		unique :name
		index :name

		def validate
			assert_present :name
			assert_present :pw
		end
	end
end
