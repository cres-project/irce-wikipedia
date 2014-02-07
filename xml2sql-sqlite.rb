#!/usr/bin/env ruby

puts "Begin;"

ARGF.each do |line|
   if line =~ /\AINSERT INTO \`(\w+)\` VALUES\s*\((.*)\);\Z/
      table = $1.dup
      rows = $2.dup.split( /\),\(/ )
      rows.each do |r|
         r.gsub!( /\\'/, "''" )
         puts %Q[INSERT INTO #{ table } VALUES (#{ r });]
      end
   end
end

puts "Commit;"
