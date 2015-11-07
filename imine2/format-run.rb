#!/usr/bin/env ruby

if $0 == __FILE__
  run_name = ARGV.shift
  query_id = nil
  ARGF.each do |line|
    case line
    when /\A## ([\w\-]+)/
      query_id = $1.dup
    else
      topic, score, = line.chomp.split(/\t/)
      puts [ run_name, query_id, topic, nil, score ].join("\t")
    end
  end
end
