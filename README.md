IRCEpedia
=========

IRCE search engine for retrieving Wikipedia articles.

百科事典記事の検索ツールです。

## 使い方

1. Wikipediaダンプデータのダウンロード
2. Wikipediaダンプデータの前処理
3. Wikipediaダンプデータの索引付け

## 1. データのダウンロード

http://dumps.wikimedia.org/ にて提供されているWikipediaのXMLダンプデータをダウンロードしてくる。

日本語版Wikipediaに関しては以下から最新のものを入手できる:
http://dumps.wikimedia.org/jawiki/latest/

必要なファイルは以下の2種類のみ:

* 記事本文 (XML):
  * jawiki-20131005-pages-articles1.xml.bz2 266.2 MB
  * jawiki-20131005-pages-articles2.xml.bz2 540.2 MB
  * jawiki-20131005-pages-articles3.xml.bz2 201.5 MB
  * jawiki-20131005-pages-articles4.xml.bz2 734.5 MB
* 記事名の一覧 (plaintext):
  * jawiki-20131005-all-titles-in-ns0.gz  8.4 MB

## 2. ダンプデータの前処理 (ext-dump.rb)

本ツールを展開したフォルダにダンプファイルを置き、以下のコマンドにて実行する:

```
$ ./ext-dump.rb jawiki-20131005-pages-articles1.xml
```

実行後は、コマンドを実行したディレクトリに 00, 01, ... ff まで2文字の英数字によるサブディレクトリが作られる。
これはインデックスが利用するキャッシュファイルとして使うので、そのまま残しておくこと（全てのダンプデータを展開した状態なので、相当の容量になるので注意すること）。

## 3. ダンプデータの索引付け (ext-dump2.rb)

```
$ ./ext-dump2.rb jawiki-20131005-all-titles-in-ns0
```

