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
         @per_page = 10
      end
      def search
         solr = WikipediaSolr.new
         result = solr.search_fulltext( @query, { :start => @page * @per_page } )
      end
      def search_random
         seed = Time.now.to_i
         solr = WikipediaSolr.new
         result = solr.search_fulltext( "*:*", { :sort => "random_#{ seed } desc" } )
      end
      def per_page=( n )
         @per_page = n
      end
      def paginate
         result = %Q[<div class="paginate">ページ:\n]
         spage = page - 6
         spage = 0 if spage < 0
         epage = spage + 15
         ( spage ... epage ).each do |i|
            if i == @page
               result << %Q[<span class="page"><strong>#{ i+1 }</strong></span>]
            else
               result << %Q[<a href="?q=#{ URI.escape @query }&amp;page=#{ i }"><span class="page">#{ i+1 }</span></a>]
            end
         end
         result << "</div>"
      end
   end
end
