require 'minitest/spec'
require 'minitest/autorun'
require'../lib/entry.rb'

MiniTest::Unit.after_tests do
	Ohm.redis.flushdb
end

describe Entry do

	before do
		Ohm.redis.flushdb
		@gk = Entry::GateKeeper.new(:db => 1)
		@user = Entry::User.new
		@user.name = "test"
		@user.pw = "foobar"
		@user.expires_at = Time.now + 600
		@user.save
		@auth = Entry::Auth.create(:time => Time.new)
	end

	after do
	end

	describe "when name is empty" do
		it "is not valid" do
			@user.name = ""
			@user.valid?.must_equal false 
		end
	end

	describe "when name is set" do
		it "must be unique" do
			proc do 
				Entry::User.create(:name => "test", :pw => "foo", :expires_at => Time.now)
			end.must_raise Ohm::UniqueIndexViolation
		end

		it "is valid" do
			@user.valid?.must_equal true
		end

		it "can be indexed" do
			Entry::User.find(:name => "test").empty?.must_equal false
		end
	end

	describe "when password is empty" do
		it "is not valid" do
			@user.pw = ""
			@user.valid?.must_equal false
		end
	end

	describe "auths keeps a list of authorizations" do
		it "can respond to a request" do
			@user.must_respond_to :auths
		end

		it "can accept a new Auth" do
			@user.auths.push(@auth).must_equal 1
		end

		it "can return the list of Auths" do
			@user.auths.push(@auth)
			@user.auths.wont_equal nil
		end

		it "can get the last login" do
			@user.auths.push(@auth)
			@user.auths.last.time.must_equal @auth.time.to_s
		end
	end

	describe "the login is valid until it expires" do
		it "will be valid if the current time is before the expire time" do
			@user.expires_at = Time.now + 600
			@user.expired?.must_equal false
		end

		it "will be invalid if the current time is after the expire time" do
			@user.expires_at = Time.now - 600
			@user.expired?.must_equal true
		end
	end
end
