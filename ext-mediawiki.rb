#!/usr/bin/env ruby

require "yaml"
require "mysql2"
require_relative "solr.rb"

if $0 == __FILE__
  indexer = WikipediaSolr.new
  conf = YAML.load( open "mysql.yml" )
  mysql = Mysql2::Client.new( conf )
  results = mysql.query( "select mwpage.page_id, mwpage.page_title, mwtext.old_text from mwpage,mwrevision,mwtext where mwtext.old_id=mwrevision.rev_text_id and mwrevision.rev_page=mwpage.page_id and mwpage.page_namespace = 0 and mwpage.page_id >= 10000 and mwpage.page_id < 20000" )
  results.each do |row|
    indexer.add( id: row["page_id"], text: row["old_text"], title: row["page_title"] )
  end
  indexer.commit
end
