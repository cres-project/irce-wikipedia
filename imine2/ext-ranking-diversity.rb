#!/usr/bin/env ruby

# カテゴリ + 多様性を元にしたランキング抽出

require_relative "ext-ranking-category.rb"
require_relative File.join(File.dirname(__FILE__), "..", "ext-mediawiki-topcategory.rb")

class Hash
  def normalize
    mean = values.inject{|sum, e| sum += e } / values.size.to_f
    var  = values.inject{|sum, e| sum += (e-mean)**2 } / values.size.to_f
    stdev = Math.sqrt( var )
    hash = {}
    self.each do |k, v|
      hash[k] = ( self[k] - mean ) / stdev
    end
    hash
  end
end

def sort_and_print(results, alpha = 0.5)
  conf_path = File.join(File.dirname(__FILE__), "..", "mysql.yml")
  conf = YAML.load( open conf_path )
  db = Mysql2::Client.new( conf )
  category_vector = {}
  results.keys.each do |title|
    STDERR.puts title
    sql = "select * from page where page_title = '#{db.escape title}' and page_namespace = 14"
    row = db.query(sql).first
    if row.nil? or row.empty?
      results.delete title
      next 
    end
    category_vector[title] = category(db, row)
  end
  scores = {}
  titles = results.keys.sort_by{|title| results[title] }.reverse
  final_results = []
  final_results << titles.shift
  while not titles.empty?
    final_scores = {}
    final_results.each do |title|
      category_vector[title].each do |k, v|
        final_scores[k] ||= 0
        final_scores[k] += v
      end
    end
    #puts "final_results: "+final_results.join(", ")
    #pp category_vector[final_results[-1]]
    #pp final_scores
    titles.each do |title|
      scores[title] = 0
      ( category_vector[title].keys + final_scores.keys ).uniq.each do |c|
        scores[title] += category_vector[title][c].to_f * final_scores[c].to_f
      end
    end
    titles.sort_by!{|title| alpha * scores.normalize[title] - (1-alpha) * results.normalize[title] }
    final_results << titles.shift
  end
  final_results.each_with_index do |title, idx|
    next if STOP_TITLES.include? title
    next if STOP_TITLES_REGEXP =~ title
    puts [title.title_normalize, [results[title],scores[title]].join(",")].join("\t")
  end
end

if $0 == __FILE__
  results = {}
  ARGF.each do |line|
    if line =~ /\A##/
      sort_and_print(results) unless results.empty?
      puts line
      results = {}
    else
      title, score, *category = line.chomp.split(/\t/)
      category.each do |c|
        results[c] ||= 0
        results[c] += score.to_f
      end
    end
  end
  sort_and_print(results) unless results.empty?
end
