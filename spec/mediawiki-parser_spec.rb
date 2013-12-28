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
         html.should_not match /<span class=\"editsection\">/
      end
      it "should support 'ファイル:' namespace for images." do
         parser = MediaWikiParser::Kiwi.new( 'オリエンテーリング' )
         html = parser.to_html
         html.should_not match /thumb(nail)?\|/
      end
      it "should include properly template recursively." do
         # for {{evalint}}
         parser = MediaWikiParser::Kiwi.new( '109' )
	 html = parser.to_html
	 html.should_not match /<onlyinclude>/
      end
      it "should parse properly a page text." do
         parser = MediaWikiParser::Kiwi.new "108% Bad News"
         proc {
            html = parser.to_html
         }.should_not raise_error
      end
      it "should parse properly a page text. (1963-1964シーズンのNBA)" do
         parser = MediaWikiParser::Kiwi.new "1963-1964シーズンのNBA"
         proc {
            html = parser.to_html( :ignore_bold => true )
         }.should_not raise_error
      end
      it "should parse properly a page text. (CHAGE_and_ASKAのコンサート一覧)" do
         parser = MediaWikiParser::Kiwi.new "CHAGE and ASKAのコンサート一覧"
         proc {
            html = parser.to_html( :ignore_bold => true )
         }.should_not raise_error
      end
   end
end
