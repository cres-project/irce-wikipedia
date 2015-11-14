#!/usr/bin/env ruby

def usage
  puts <<EOF
Usage: ./run-topics.rb search-script topic-file

  Example:
    ./run-topic.rb ./ext-ranking.rb IMine2-J-Queries.tsv

EOF
end

if $0 == __FILE__
  if ARGV.size < 2
    usage()
    exit
  end
  command = ARGV[0]
  topics = open(ARGV[1]) do |io|
    io.readlines
  end
  topics.each do |line|
    topic_id, query, = line.chomp.split(/\t/)
    puts "## #{ topic_id }\t#{ query }"
    system "#{ command } #{ query }"
  end
end
