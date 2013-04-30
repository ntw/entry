require 'redis'
require 'ohm'

module Entry
	def self.connect(options = {})
		Ohm.connect(options)
	end

	def self.authorized?(options = {})
		def_options = {:name => "", :pw => ""}
		options = def_options.merge(options)
		user = User.find(:name => options[:name]).first
		(user != nil) && (user.pw == options[:pw]) && (!user.expired?)
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
		unique :email
		index :name
		index :email

		def validate
			assert_present :name
			assert_present :pw
			assert_present :expires_at
			assert_numeric :expires_at
		end

		def expired?
			Time.now.to_i > expires_at.to_i
		end
	end
end
