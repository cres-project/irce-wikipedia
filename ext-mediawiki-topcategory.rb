#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require_relative "ext-mediawiki.rb"

def category( db, page, depth = 0, weight = 1.0 )
  result = {}
  if depth > 6
    result[:not_found] = weight 
    return result
  end
  #puts [ "*" * depth, page["page_title"], page["page_id"], weight ].join("\t")
  sql = "select * from categorylinks where cl_from = #{ page["page_id"] }"
  categories = db.query( sql )
  unless categories.size > 0
    result[:not_found] = weight 
    return result
  end
  categories.each do |row|
    category = row[ "cl_to" ]
    sql = "select page_id, page_title from page where page_title = '#{ db.escape category }' and page_namespace = 14"
    db.query( sql ).each do |parent_category|
      cat_title = parent_category[ "page_title" ].force_encoding( "utf-8" )
      case cat_title
      when "総記", "学問", "技術", "自然", "社会", "地理", "人間", "文化", "歴史"
        result[ parent_category[ "page_title" ] ] = weight / categories.size
      else
        category( db, parent_category, depth + 1, weight / categories.size ).each do |k, v|
          result[ k ] ||= 0.0
          result[ k ] += v
        end
      end
    end
  end
  result
end

if $0 == __FILE__
  page_id = ARGV[0] || 5
  page_id = page_id.to_i
  #p page_id
  conffile = File.join( File.dirname(__FILE__), "mysql.yml" )
  conf = YAML.load( open conffile )
  db = Mysql2::Client.new( conf )
  pp category( db, { "page_id" => page_id, "page_title" => "アンパサンド" } )
end
