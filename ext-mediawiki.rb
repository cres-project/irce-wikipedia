#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "yaml"
require "mysql2"
require_relative "solr.rb"
require_relative "mediawiki-parser.rb"

if $0 == __FILE__
  indexer = WikipediaSolr.new
  conf = YAML.load( open "mysql.yml" )
  mysql = Mysql2::Client.new( conf )
  results = []
  idx = 0 
  interval = 10000
  while idx == 0 or results.size > 0
    STDERR.puts "subset: #{ idx } .. #{ idx + interval }"
    sql = <<EOF
	select page.page_id, page.page_title, text.old_text
		from page,revision,text
		where text.old_id = revision.rev_text_id
			and revision.rev_page = page.page_id
			and page.page_namespace = 0
			and page.page_is_redirect != 1
			and page.page_id between #{ idx } and #{ idx + interval }
EOF
    results = mysql.query( sql, cast: false )
    results.each do |row|
      title_s = mysql.escape( row["page_title"] )
      rd_sql = <<EOF
	select * from page, redirect
		where redirect.rd_title = '#{ title_s }'
			and redirect.rd_namespace = 0
			and page.page_id = redirect.rd_from
EOF
      redirects = []
      mysql.query( rd_sql ).each do |r|
        page_title = r["page_title"].gsub( /_+/, " " )
        redirects << [ page_title, r["rd_fragments"] ].join(" ").strip
      end
      #parser = MediaWikiParser::Cmdline.new( row["page_title"], row["old_text"] )
      parser = MediaWikiParser::Kiwi.new( row["page_title"], row["old_text"] )
      text = parser.to_text( :no_expand_template => true, :ignore_bold => true, :notoc => true )
#puts text
      page_title = row["page_title"].gsub( /_+/, " " )
      indexer.add( id: row["page_id"],
                   text: row["old_text"],
		   highlight_text: text,
		   title: row["page_title"],
                   title_s: page_title,
		   redirects: redirects,
		 )
      STDERR.puts [ row["page_id"], row["page_title"], redirects.join(", ") ].join( "\t" )
    end
    indexer.commit
    idx += interval
  end
end
