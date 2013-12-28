#!/usr/bin/env ruby

$:.push File.dirname( __FILE__ )
require "index.rb"

begin
   time = Time.now
   cgi = CGI.new
   app = WebApp::WikipediaSearch.new( cgi )
   data = {}
   if app.query
      data[ :results ] = app.search
      #pp data
      #data[ :results ] = results[ "doc" ]
      data[ :elapsed ] = Time.now - time
   else
      data[ :results ] = app.search_random
   end
   print cgi.header( "text/html; charset=utf-8" )
   print app.to_html( data )
rescue
   print "Content-Type: text/plain\r\n\r\n"
   puts "#$! (#{$!.class})"
   puts ""
   puts $@.join( "\n" )
end
