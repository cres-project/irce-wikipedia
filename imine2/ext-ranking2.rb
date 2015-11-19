#!/usr/bin/env ruby

# カテゴリを元にしたランキング抽出

class String
  def title_normalize
    title = self.gsub(/(関連の|の|に関する)?(?:サブ)?スタブ(?:項目|記事)?\z/, "")
    title.gsub(/関連の加筆依頼項目\z/, "").gsub(/\A漫画作品 .*/, "漫画作品").gsub(/\A学校記事\z/, "学校")
  end
end

STOP_TITLES = %w( 書きかけの節のある項目 曖昧さ回避 すべての曖昧さ回避 生年未記載 プロジェクト人物伝項目 未完成の一覧 正確性 解消済み仮リンクを含む記事 編集半保護中の記事 単一の出典 大言壮語的な記述になっている項目 長大な項目名 テンプレート呼び出しで引数が重複しているページ )
STOP_TITLES_REGEXP = Regexp.new( '\A' + %w( 出典を必要とする記述のある記事/ 出典を必要とする記事/ 出典を必要とする節のある記事/ 無効な出典が含まれている記事/ 出典皆無な存命人物記事/ 出典を必要とする存命人物記事/
検証が求められている記述のある記事/
言葉を濁した記述のある記事
特筆性の基準を満たしていないおそれのある記事
翻訳中途 独自研究の除去が必要な記事/ 独自研究の除去が必要な節のある記事/ 宣伝活動の記述のある項目/ 外部リンクがリンク切れになっている記事 国際化が求められている項目 
プロジェクト性
                               ).map{|e| Regexp.escape(e) }.join('|') )
def print_results(results)
  results.keys.sort_by{|title| results[title] }.reverse.each do |title|
    next if STOP_TITLES.include? title
    next if STOP_TITLES_REGEXP =~ title
    puts [title.title_normalize, results[title]].join("\t")
  end
end

if $0 == __FILE__
  results = {}
  ARGF.each do |line|
    if line =~ /\A##/
      print_results(results) unless results.empty?
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
  print_results(results) unless results.empty?
end
