#!/usr/bin/env ruby

require "./lib/package_checker"
require 'dotenv'

Dotenv.load

checker = PackageChecker.new :username => ENV["BL_USERNAME"], :password => ENV["BL_PASSWORD"]
packages = checker.packages

if packages.empty?
  puts "No packages"
else
  if packages.count == 1
    puts "1 package waiting to be picked up:"
  else
    puts "#{packages.count} packages waiting to be picked up:"
  end
  packages.each do |package|
    puts "- #{package.carrier}: #{package.tracking_number} (delivered #{package.delivered.strftime("%m/%d/%Y at %I:%M%p")})"
  end
end
