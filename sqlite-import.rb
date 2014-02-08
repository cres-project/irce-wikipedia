#!/usr/bin/env ruby

# Use sqlite3 api directly.

require "rubygems"
require "sqlite3"

dbh = SQLite3::Database.new( "my_wiki.sqlite" )

count = 0
start_time = Time.now
dbh.transaction do
   ARGF.each do |line|
      if line =~ /\AINSERT INTO \`(\w+)\` VALUES\s*\((.*)\);\Z/
         #puts $.
         table = $1.dup
         pattern = /\),\((?=\d+)/
         pattern = /\),\((?=\d\d+)/ if table == "text"
         rows = $2.dup.split( pattern )
         rows.each do |r|
            if table == "text"
            end
            #p r
            ## "'girl\'s'" should be "'girl''s'"
            ## "'\'" should become "'\\'" (as-is).
            r = r.gsub( /\\(.)/ ) do |m|
               if $1 == "'"
                  "''"
               else
                  m
               end
            end
            sql = %Q[INSERT INTO #{ table } VALUES (#{ r })]
            #open( "z", "w" ){|io| io.puts sql }
            #puts sql
            dbh.execute( sql )
            count += 1
            if ( count % 10000 ) == 0
               puts "#{ count } records, #{ Time.now - start_time } elapsed."
            end
         end
      end
   end
end
puts "#{ count } records, #{ Time.now - start_time } elapsed."
