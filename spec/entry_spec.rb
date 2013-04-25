require 'minitest/autorun'
require'../lib/entry.rb'

describe Entry do

	before do
		@gk = Entry::GateKeeper.new(:db => 1)
		@user = Entry::User.new
	end

	after do
		Ohm.redis.flushdb
	end

	describe "when name is empty" do
		it "is not valid" do
			@user.valid?.must_equal false 
		end
	end

	describe "when key is empty" do
		it "is not valid" do
			@user.valid?.must_equal false
		end
	end

	describe "when name is set" do
		it "must be unique" do
			@user.name = "test"
			@user.save
			proc {Entry::User.create(:name => "test")}.must_raise Ohm::UniqueIndexViolation
		end
	end

	describe "when name is set" do
		it "is valid" do
			@user.name = "test"
			@user.valid?.must_equal true
		end
	end
end
