#!/usr/bin/env ruby

if $0 == __FILE__
  run_name = ARGV.shift
  query_id = nil
  query = nil
  done = {}
  ARGF.each do |line|
    case line
    when /\A## ([\w\-]+?)\t(.+?)\Z/
      query_id = $1.dup
      query = $2.dup
    else
      topic, score, = line.chomp.split(/\t/)
      next if done[query_id] and done[query_id].size >= 10
      next if topic == query
      next if query =~ /#{topic}/i
      if topic == "存命人物"
        topic = "人物"
      end
      unless topic.include?( query ) 
        topic = [ query, topic ].join(" ")
      end
      next if done[query_id] and done[query_id].include?(topic)
      puts [ query_id, topic, nil, score, run_name ].join("\t")
      done[query_id] ||= []
      done[query_id] << topic
    end
  end
end
