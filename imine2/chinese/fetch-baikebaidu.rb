#!/usr/bin/env ruby

require "uri"
require "open-uri"

def baidu_query( query )
  result = []
  url = "http://baike.baidu.com/search?word=#{ URI.escape query }&pn=0&rn=0&enc=utf8"
  lines = open(url){|io| io.readlines }
  lines.each do |line|
    case line
    when /<a class="result-title" href="(http:\/\/baike.baidu.com\/(view\/\d+\.htm|subview\/\d+\/\d+\.htm))"/
      result << $1
    end
  end
  result
end

if $0 == __FILE__
  ARGF.each do |line|
    query_id, query, = line.split(/\t/)
    result = baidu_query( query )
    open(query_id+"_url.txt", "w"){|io|
      io.puts result
    }
    sleep 10
  end
end
