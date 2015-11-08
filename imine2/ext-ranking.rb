#!/usr/bin/env ruby

BASEDIR = File.dirname(__FILE__)
require File.join(BASEDIR, "..", "solr.rb")

if $0 == __FILE__
  solr = WikipediaSolr.new
  query = ARGV[0] || "cvs"
  result = solr.search_fulltext(query, rows: 100)
  docs = result[ "response" ][ "docs" ]
  docs.each do |doc|
    puts [doc["title"], doc["score"]].join("\t")
  end
end
