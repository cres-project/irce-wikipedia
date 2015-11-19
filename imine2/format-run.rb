#!/usr/bin/env ruby

if $0 == __FILE__
  run_name = ARGV.shift
  query_id = nil
  done = {}
  ARGF.each do |line|
    case line
    when /\A## ([\w\-]+)/
      query_id = $1.dup
    else
      topic, score, = line.chomp.split(/\t/)
      next if done[query_id] and done[query_id] >= 10
      puts [ query_id, topic, nil, score, run_name ].join("\t")
      done[query_id] ||= 0
      done[query_id] += 1
    end
  end
end
