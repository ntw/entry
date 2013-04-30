#!/usr/bin/env ruby

require '../lib/entry.rb'
require 'trollop'

opts = Trollop::options do
	opt :name, "User's name", :type => String
	opt :pw, "User's password", :type => String
end

Entry.connect

puts Entry.authorized?(opts)
