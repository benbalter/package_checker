#!/usr/bin/env ruby

require 'pry'
require './lib/package_checker.rb'
require 'dotenv'

Dotenv.load
checker = PackageChecker.new :username => ENV["BL_USERNAME"], :password => ENV["BL_PASSWORD"]
binding.pry
