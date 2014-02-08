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
         rows = $2.dup.split( /\),\(/ )
         rows.each do |r|
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
            #p sql
            dbh.execute( sql )
            if ( count % 10000 ) == 0
               elapsed = Time.now - start_time
               puts [ count, elapsed ].join( "\t" )
            end
            count += 1
         end
      end
   end
end
