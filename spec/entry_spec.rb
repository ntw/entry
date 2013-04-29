require 'minitest/spec'
require 'minitest/autorun'
require'../lib/entry.rb'

describe Entry do

	before do
		@gk = Entry::GateKeeper.new(:db => 1)
		@user = Entry::User.new
		@user.name = "test"
		@user.pw = "foobar"
		@user.save
	end

	after do
		Ohm.redis.flushdb
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
	end
end
