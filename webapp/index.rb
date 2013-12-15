#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
# $Id$

require "cgi"
require "erb"
require "pp"

$:.push File.join( File.dirname( __FILE__ ), ".." )
require "solr.rb"

module WebApp
   class Base
      TITLE = "百科事典サーチ ircepedia"
      def to_html( data, template = "template.html" )
         eval_rhtml( template, binding )
      end
      include ERB::Util
      def eval_rhtml( fname, binding )
         rhtml = open( fname ){|io| io.read }
         result = ERB::new( rhtml, $SAFE, "<>" ).result( binding )
      end
   end
   class WikipediaSearch < Base
      attr_reader :query, :page
      def initialize( cgi )
         @cgi = cgi
         @page = @cgi.params["page"][0].to_i
         @query = @cgi.params["q"][0]
      end
      def search
         solr = WikipediaSolr.new
         result = solr.search_fulltext( @query )
      end
   end
end
