#!/usr/bin/env ruby

require '../lib/entry.rb'
require 'trollop'

user_attributes = Entry::User.attributes
opts = Trollop::options do
	user_attributes.each do |attribute|
		opt attribute, "User's #{attribute}", :type => String
	end
end

Entry.connect

user = Entry::User.find(:name => opts[:name])
if user.size == 0 
	user = Entry::User.new
else user = user.first #first ought to be the only option
end

user_attributes.each do |key|
	user.send(key.to_s+"=", opts[key])
end

user.save
