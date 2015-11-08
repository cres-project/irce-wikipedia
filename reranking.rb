#!/usr/bin/env ruby

require_relative "solr.rb"
require_relative "ext-mediawiki-topcategory.rb"

class WikipediaSolr
  def reranking( response, params = { :alpha => 0.5 } )
    alpha = params[ :alpha ] || 0.5
    docs = response[ "response" ][ "docs" ]
    results = []
    results << docs.shift
    until docs.empty? do
      previous_categories = results.map{|e| e[ "category" ] }.flatten.uniq
      count = 0
      docs.sort_by! do |e| 
        count += 1
        score = e[ "score" ].to_f
        category = e[ "category" ]
        cat_score = 0.1
	if not category.empty?
	  cat_score = 1 - ( Set[ *previous_categories ] & Set[ *category ] ).size / category.size.to_f
        end
        e[ "cat_score" ] = cat_score
        reranking_score = alpha * score * ( 1-alpha ) * cat_score
        e[ "reranking_score" ] = reranking_score
        [ -reranking_score, -score, count ]
      end
      results << docs.shift
    end
    results
  end
  def reranking2( response, params = { :alpha => 0.5 } )
    alpha = params[ :alpha ] || 0.5
    docs = response[ "response" ][ "docs" ]
    conf = YAML.load( open "mysql.yml" )
    db = Mysql2::Client.new( conf )
    docs.each do |d|
      d[ "top_category" ] = category( db, {"page_id"=>d["id"]} )
      #p [d["title"],d["top_category"]]
    end
    results = []
    results << docs.shift
    until docs.empty? do
      previous_categories = Hash.new( 0.0 )
      results.each do |e|
        e[ "top_category" ].each do |k,v|
	  previous_categories[k] += v
	end
      end
      p previous_categories
      count = 0
      docs.sort_by! do |e| 
        count += 1
        score = e[ "score" ].to_f
        category = e[ "category" ]
        cat_score = 0.1
        if not category.empty?
          cat_score = 0
          e[ "top_category" ].each do |k,v|
	    cat_score += v * previous_categories[k]
          end
          cat_score = cat_score
        end
p e["top_category"]
p cat_score
        e[ "cat_score" ] = cat_score
        reranking_score = alpha * score * ( 1-alpha ) * cat_score
        e[ "reranking_score" ] = reranking_score
        [ -reranking_score, -score, count ]
      end
      results << docs.shift
    end
    results
  end
end

if $0 == __FILE__
  solr = WikipediaSolr.new
  #solr.add( { :title => "test" } )
end
if $0 == __FILE__
  query = ARGV[0] || "java"
  alpha = ARGV[1].to_f
  alpha = nil if alpha == 0.0
  solr = WikipediaSolr.new
  result = solr.reranking2( solr.search_fulltext( query, rows: 10 ), alpha: alpha )
  result.each do |d|
    puts [ d["title"], "%.03f" % d["score"], 
           d["cat_score"] ? "%.03f" % d["cat_score"] : "", 
           d["reranking_score"] ? "%.03f" % d["reranking_score"] : ""
          ].join( "\t" ) 
    #puts [ d["title"], d["score"], d["cat_score"], d["reranking_score"], d["category"].join(",") ].join( "\t" ) 
  end
end
