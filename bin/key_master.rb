#!/usr/bin/env ruby

require '../lib/entry.rb'
require 'trollop'

SUB_COMMANDS = %w(add delete update)
Trollop::options do
end
cmd = ARGV.shift
opts = case cmd
when "add"
	Trollop::options do
		Entry::User.attributes.each do |a|
			opt a.to_sym, "The user's #{a.to_s}", :type => String
		end
	end
when "delete", "update"
	Trollop::options do
		Entry::User.indices.each do |i|
			opt i.to_sym, "The user's #{i.to_s}", :type => String
		end
	end
else Trollop::die "unknown command #{cmd.inspect}.  Available commands are #{SUB_COMMANDS}"
end
opts[cmd.to_sym] = true

puts(opts)


