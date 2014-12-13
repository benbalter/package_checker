#!/usr/bin/env ruby

require "./package_checker"
require 'dotenv'

Dotenv.load

checker = PackageChecker.new :username => ENV["BL_USERNAME"], :password => ENV["BL_PASSWORD"]
puts checker.events
