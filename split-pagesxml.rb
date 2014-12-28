#!/usr/bin/env ruby

count = 0
header = ""
BOUNDARY = 100

io = open( "%04d.txt" % count, "w" )

ARGF.each do |line|
  if line =~ /<page>/
    count += 1
    if count % BOUNDARY == 0
      io.print "</mediawiki>"
      io.close
      io = open( "%04d.txt" % ( count / BOUNDARY ), "w" )
      io.print header
    end
  else
    if count == 0
      header << line
    end
  end
  io.print line
end
