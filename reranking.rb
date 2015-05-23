#!/usr/bin/env ruby

require_relative "solr.rb"

if $0 == __FILE__
  query = ARGV[0] || "java"
  alpha = ARGV[1].to_f
  alpha = nil if alpha == 0.0
  solr = WikipediaSolr.new
  result = solr.reranking( solr.search_fulltext( query ), alpha: alpha )
  result.each do |d|
    puts [ d["title"], d["score"], d["cat_score"], d["reranking_score"] ].join( "\t" ) 
    #puts [ d["title"], d["score"], d["cat_score"], d["reranking_score"], d["category"].join(",") ].join( "\t" ) 
  end
end
