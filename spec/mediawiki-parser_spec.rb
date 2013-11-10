#!ruby
# -*- coding: utf-8 -*-

require "mediawiki-parser.rb"

describe "mediawiki-parser.rb" do
   context "#to_html" do
      it "should parse properly the page '言語'." do
         parser = MediaWikiParser::Kiwi.new( '言語' )
         html = parser.to_html
         html.should match /<b>言語<\/b>/
      end
      it "should not include Editsection in the final contents." do
         parser = MediaWikiParser::Kiwi.new( '言語' )
         html = parser.to_html
         html.should_not match /<span class="editsection">/
      end
      it "should support 'ファイル:' namespace for images." do
         parser = MediaWikiParser::Kiwi.new( 'オリエンテーリング' )
         html = parser.to_html
         html.should_not match /thumb(nail)?\|/
      end
   end
end
