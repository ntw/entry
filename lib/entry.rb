require 'redis'
require 'ohm'

module Entry
	def self.connect(options = {})
		Ohm.connect(options)
	end

	class Auth < Ohm::Model
		attribute :time
	end

	class User < Ohm::Model
		attribute :name
		attribute :pw
		attribute :expires_at
		attribute :email
		list :auths, Auth
		unique :name
		index :name
		index :email

		def validate
			assert_present :name
			assert_present :pw
			assert_present :expires_at
		end

		def expired?
			Time.now > self.expires_at
		end
	end
end
