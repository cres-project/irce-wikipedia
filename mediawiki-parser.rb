#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "pp"
require "open3"
require "htmlentities"

require_relative "ext-xmldump.rb"

begin
   $:.push File.join( File.dirname(__FILE__), "..", "kiwi", "ffi" )
   require "yapwtp.rb"
rescue LoadError
end

module MediaWikiParser
   class Base
      Namespace_name = {
         "" => "",
         "-2" => "Media", "-1" => "Special", "0" => "",
         "2"  => "User", "4" => "Wikipedia", "6" => "File",
         "8" => "MediaWiki", "10" => "Template", "12" => "Help",
         "14" => "Category",
	 "1" => "Talk", "3" => "User talk", "5" => "Wikipedia talk",
	 "9" => "MediaWiki talk", "11" => "Template talk", "13" => "Help talk",
	 "15" => "Category talk",
      }
      attr_reader :parser, :cache, :title
      def initialize( title, text = nil ); end
      def to_html( options = {} ); end
      def to_text( options = {} )
         entities = HTMLEntities.new
         html = self.to_html( options )
	 html.gsub!( /<\/?\w+.[^>]*>/, " " )
         entities.decode( html )
      end
   end

   class Kiwi < Base
      def initialize( title, text = nil )
         @title = title
         @parser = WikiParser.new
         @cache = MyWikipediaDumps::CachePage.new( title )
         @text = text
         #STDERR.puts @text.encoding
         #STDERR.puts "#{ self.class } initialized."
      end
      def to_html( options = {} )
         # linkto_baseurl = "", no_expand_template = false, include = false,
	 html = nil
         #p @title
         text = @text
         unless text
            text = open( cache.filename ){|io| io.read }
         end
	 if options[ :include ]
	    if text =~ /<onlyinclude>(.*?)<\/onlyinclude>/mo
	       text = $1.dup
	    end
	    text.gsub!( /<noinclude>.*?<\/noinclude>/mo, "" )
	    text.gsub!( /<\/?includeonly>/mo, "" )
	    #p text
	 end
         if options[ :no_expand_template ]	# strip templates.
	    while( text.gsub!( /\{\{\{[^\{\}]*\}\}\}/mo, "" ) or text.gsub!( /\{\{[^\{\}]*\}\}/mo, "" ) )
            end
            #text.gsub!( /\{\{\{[^\{\}]*\}\}\}/mo, "" )
            #text.gsub!( /\{\{[^\{\}]*\}\}/mo, "" )
         end
	 if options[ :ignore_bold ]
	    text.gsub!( /'''/o, "" )
            text.gsub!( /''/o, "" )
	 end
	 html = parser.html_from_string( text )
         html.force_encoding( "utf-8" )
         templates = @parser.templates
         templates.each do |template|
            #STDERR.puts template.inspect
            template.each do |k,v|
              template[k] = v.force_encoding( "utf-8" ) if v.respond_to? :encode
            end
            if options[ :no_expand_template ]
               html.gsub!( template[ :replace_tag ], "" )
	    else
               case template[ :name ]
               when "PAGENAME"
                  html.gsub!( template[ :replace_tag ], @title )
               when /DEFAULTSORT:/
                  html.gsub!( template[ :replace_tag ], "" )
               when /ns:(\w+)/
                  #STDERR.puts [ $1, Namespace_name[ $1.to_s ] ].inspect
                  html.gsub!( template[ :replace_tag ], Namespace_name[ $1.to_s ] )
               else
                  template_title = template[ :name ].strip
                  template_title.sub!( /\A(.)/ ){|e| e.upcase }
                  parser2 = self.class.new( "Template:#{ template_title }" )
		  options2 = options.merge( { :include => true } )
                  if File.exist? parser2.cache.filename
                     html.gsub!( template[ :replace_tag ], parser2.to_html( options2 ) )
                  else
                     html.gsub!( template[ :replace_tag ], "" )
                     warn "Template file not found, skip:\t{{#{ template_title }}}, #{ parser2.cache.filename }"
                  end
               end
            end
         end
         html.gsub!( /<a href="\//, "<a href=\"#{ options[ :baseurl ] }" ) if options[ :baseurl ]
	 html.gsub!( /<span class="editsection">.*?<\/span>/io, '' )
	 html
      end
   end

   class Cmdline < Base
      BASEDIR = File.join( File.dirname(__FILE__), "..", "mediawiki", "maintenance" )
      def initialize( title, text = nil )
         @title = title
         @text = text
      end
      def to_html( base_url )
         ENV.delete "REQUEST_METHOD"
         text = @text
         unless text
            text = open( cache.filename ){|io| io.read }
         end
         cmd = [ "php", File.join( BASEDIR, "parse.php" ), "--title", @title ]
         html = Open3.popen3( *cmd ) do |pin, pout, perr, wait_thread|
           pin.print text
           pin.close
#STDERR.puts "to_html : #@title : #{text[0..30].inspect}"
#STDERR.puts cmd.inspect
#STDERR.puts [pin, pout, perr, wait_thread].inspect
           #wait_thread.join
           #STDERR.puts perr.read
           html = pout.read
         end
	 html.gsub!( /<span class="mw-editsection"><span class="mw-editsection-bracket">\[<\/span>.*?edit<\/a><span class="mw-editsection-bracket">\]<\/span><\/span>/io, '' )
	 html
      end
   end
end

if $0 == __FILE__
   title = ARGV[0] || "言語"
   parser = MediaWikiParser::Kiwi.new( title, open("z").read )
   #parser = MediaWikiParser::Cmdline.new( title )
   #puts parser.to_html( :ignore_bold => true, :no_expand_template => true )
puts parser.to_text
end
