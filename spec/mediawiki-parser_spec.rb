#!ruby
# -*- coding: utf-8 -*-

require "mediawiki-parser.rb"

describe "cinii.rb" do
   it "should parse properly the page '言語'" do
      parser = MediaWikiParser::Kiwi.new( '言語' )
      parser.to_html
   end
end
