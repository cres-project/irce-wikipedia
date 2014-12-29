#!/usr/bin/env ruby

require "yaml"
require "mysql2"
require_relative "solr.rb"

if $0 == __FILE__
  indexer = WikipediaSolr.new
  conf = YAML.load( open "mysql.yml" )
  mysql = Mysql2::Client.new( conf )
  results = mysql.query( <<EOF )
	select mwpage.page_id, mwpage.page_title, mwtext.old_text 
		from mwpage,mwrevision,mwtext
		 where mwtext.old_id = mwrevision.rev_text_id
			and mwrevision.rev_page = mwpage.page_id
			and mwpage.page_namespace = 0
			and mwpage.page_is_redirect != 1
			and mwpage.page_id >= 40000
			and mwpage.page_id < 50000
EOF
  results.each do |row|
    title_s = mysql.escape( row["page_title"] )
    rd_sql = <<EOF
	select * from mwpage, mwredirect
		where mwredirect.rd_title = '#{ title_s }'
			and mwredirect.rd_namespace = 0
			and mwpage.page_id = mwredirect.rd_from
EOF
    redirects = []
    mysql.query( rd_sql ).each do |r|
      redirects << [ r["page_title"], r["rd_fragments"] ].join(" ")
    end
    indexer.add( id: row["page_id"], text: row["old_text"], title: row["page_title"], redirects: redirects )
    STDERR.puts [ row["page_id"], row["page_title"], redirects.inspect ].join( "\t" )
  end
  indexer.commit
end
