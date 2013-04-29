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
			proc {Entry::User.create(:name => "test", :pw => "foo")}.must_raise Ohm::UniqueIndexViolation
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
			@user.auths.unshift(@auth).must_equal 1
		end

		it "can return the list of Auths" do
			@user.auths.unshift(@auth)
			@user.auths.wont_equal nil
		end
	end
end
