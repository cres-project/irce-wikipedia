#!/usr/bin/env ruby

require "cgi"
require "erb"

class WikipediaSearchApp
   attr_reader :query, :page
   def initialize( cgi )
      @cgi = cgi
      @page = @cgi.params["page"][0].to_i
      @query = @cgi.params["q"][0]
   end

   def to_html( data, template = "template.html" )
      eval_rhtml( template, binding )
   end

   include ERB::Util
   def eval_rhtml( fname, binding )
      rhtml = open( fname ){|io| io.read }
      result = ERB::new( rhtml, $SAFE, "<>" ).result( binding )
   end
end

begin
   time = Time.now
   cgi = CGI.new
   app = WikipediaSearchApp.new( cgi )
   data = {}
   if app.query
      data[ :results ] = app.search
      data[ :elapsed ] = Time.now - time
   end
   print cgi.header( "text/html; charset=utf-8" )
   print app.to_html( data )
rescue
   print "Content-Type: text/plain\r\n\r\n"
   puts "#$! (#{$!.class})"
   puts ""
   puts $@.join( "\n" )
end
