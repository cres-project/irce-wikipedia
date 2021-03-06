#!ruby
# -*- coding: utf-8 -*-

require "mediawiki-parser.rb"

RSpec.configure do |c|
   c.filter_run_excluding :skip => true
end

describe "mediawiki-parser.rb" do
   context "Kiwi", :skip => true do
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
   context "Cmdline" do
      it "should parse properly the page '言語'." do
         parser = MediaWikiParser::Cmdline.new( '言語' )
         html = parser.to_html( :base_url => "?title=" )
         html.should match /<b>言語<\/b>/
         #p html
         html.should include "Portal:言語学"
      end
      it "should not include a red link." do
         parser = MediaWikiParser::Cmdline.new( '言語' )
         html = parser.to_html( :base_url => "?title=" )
         html.should_not match /<a [^>]*\bclass=\"new\"/
      end
   end
end
