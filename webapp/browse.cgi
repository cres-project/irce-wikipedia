#!/usr/bin/env ruby

require "cgi"
require "erb"
require "pp"

require_relative "ircepedia.rb"
require_relative "../mediawiki-parser.rb"

module WebApp
   class WikipediaBrowse < Base
      attr_reader :title
      def initialize( cgi )
         @cgi = cgi
         @title = @cgi.params["title"][0]
      end
   end
end

begin
   cgi = CGI.new
   app = WebApp::WikipediaBrowse.new( cgi )
   data = {}
   if app.title
      parser = MediaWikiParser::Cmdline.new( app.title )
      #parser = MediaWikiParser::Kiwi.new( app.title )
      data[ :body ] = parser.to_html( :baseurl => "?title=" )
   end
   print cgi.header( "text/html; charset=utf-8" )
   print app.to_html( data, "template.html" )
rescue
   print "Content-Type: text/plain\r\n\r\n"
   puts "#$! (#{$!.class})"
   puts ""
   puts $@.join( "\n" )
end
