#!/usr/bin/env ruby

require '../lib/entry.rb'
require 'trollop'

opts = Trollop::options do
	opt :add, "Add a user to the database", :short => 'a'
	opt :delete, "Delete a user from the database", :short => 'd'
	opt :update, "Update a user in the database", :short => 'u'
	Entry::User.attributes.each do |a|
		opt a.to_sym, "The user's #{a.to_s}"
	end
end
