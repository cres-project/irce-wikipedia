#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require "cgi"
require "digest/md5"
require "json"
require "yaml"
require "mysql2"

# Usage:
# ./commons-api.cgi titles=File:Konosu_Ara_River_Aqueduct_3.JPG "iiprop=timestamp|user|comment|url|size|sha1|metadata|mime|mediatype|extmetadata" prop=imageinfo iimetadataversion=2 iiextmetadatamultilang=1 format=json action=query redirects=true uselang=ja

## commonswiki imageinfo api (dummy)
#
#request parameters:
# https://commons.wikimedia.org/w/api.php?titles=File%3AQuestion_book-4.svg&iiprop=url%7Cthumbnail%7Ctimestamp&iiurlwidth=50&iiurlheight=40&iiurlparam=50px&prop=imageinfo&format=json&action=query&redirects=true&uselang=ja
#response (json):
=begin
{"query"=>
  {"normalized"=>
    [{"from"=>"File:Question_book-4.svg", "to"=>"File:Question book-4.svg"}],
   "pages"=>
    {"4133169"=>
      {"pageid"=>4133169,
       "ns"=>6,
       "title"=>"File:Question book-4.svg",
       "imagerepository"=>"local",
       "imageinfo"=>
        [{"timestamp"=>"2008-09-11T00:44:37Z",
          "thumburl"=>
           "https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/Question_book-4.svg/50px-Question_book-4.svg.png",
          "thumbwidth"=>50,
          "thumbheight"=>39,
          "url"=>
           "https://upload.wikimedia.org/wikipedia/commons/6/64/Question_book-4.svg",
          "descriptionurl"=>
           "https://commons.wikimedia.org/wiki/File:Question_book-4.svg"}]}}}}
=end

COMMONS_BASEURL = {
  :upload => "https://upload.wikimedia.org/wikipedia/commons/",
  :wiki   => "https://commons.wikimedia.org/wiki/",
}
JAWIKI_BASEURL = {
  :upload => "https://upload.wikimedia.org/wikipedia/ja/",
  :wiki   => "https://ja.wikipedia.org/wiki/",
}
def image_suffix?( title )
  title.match( /\.(gif|jpe?g|png)\Z/i )
end
def raw_filename( title )
  filename = title.sub( /\A(File|Image|Media|ファイル|画像|メディア)\:/, "" )
end
def query_image_db( title, database = "mediawiki" )
  mysql_conf_fname = File.join( File.dirname( __FILE__ ), "..", "mysql.yml" )
  conf = YAML.load( open mysql_conf_fname )
  conf[ "database" ] = database
  mysql = Mysql2::Client.new( conf )
  title_s = mysql.escape( title )
  row = mysql.query( "select * from image where img_name = '#{ title_s }'" )
  row.first
end
def make_imageinfo( title, params = {} )
  fname = raw_filename( title )
  baseurl = JAWIKI_BASEURL
  image_row = query_image_db( fname, "jawiki" )
  #p [ title, image_row ]
  unless image_row
    baseurl = COMMONS_BASEURL
    image_row = query_image_db( fname, "commonswiki" )
    return {} unless image_row
  end
  hash = Digest::MD5.hexdigest( fname )
  result = {}
  iiprop = params[ "iiprop" ]
  iiprop = 'timestamp|user' if iiprop.nil? or iiprop.empty?
  iiprop.split( /\|/ ).each do |prop|
    case prop
    when "timestamp"
      t = image_row[ "img_timestamp" ]
      result[ :timestamp ] = "#{ t[0,4] }-#{ t[4,2] }-#{ t[6,2] }T#{ t[8,2] }:#{ t[10,2] }:#{ t[12,2] }Z"
    when "user"
      result[ :user ] = image_row[ "img_user_text" ].force_encoding( "utf-8" )
      #STDERR.puts image_row[ "img_user_text" ].encoding
      #STDERR.puts image_row[ "img_user_text" ]
    when "userid"
      result[ :user ] = image_row[ "img_user" ]
    when "url", "thumbnail"
      result[ :url ] = "#{ baseurl[:upload] }#{ hash[0,1] }/#{ hash[0,2] }/#{ fname }"
      result[ :descriptionurl ] = "#{ baseurl[:wiki] }#{ title }"
      width = params[ "iiurlwidth" ].to_i
      if width > 0
        result[ :thumburl ] = "#{ baseurl[:upload] }thumb/#{ hash[0,1] }/#{ hash[0,2] }/#{ fname }/#{ width }px-#{ fname }"
        result[ :thumburl ] << ".png" if not image_suffix? title
        result[ :thumbwidth ] = width
	original_width = image_row[ "img_width" ].to_f
	scale = ( width / original_width )
        result[ :thumbheight ] = ( image_row[ "img_height" ].to_f * scale ).to_i
      end
    when "size"
      result[ :size ] = image_row[ "img_size" ]
      result[ :width ] = image_row[ "img_width" ]
      result[ :height ] = image_row[ "img_height" ]
    when "sha1"
      result[ :sha1 ] = image_row[ "img_sha1" ]
    when "mime"
      result[ :mime ] = image_row[ "img_major_mime" ] + "/" + image_row[ "img_minor_mime" ]
    when "mediatype"
      result[ :mediatype ] = image_row[ "img_media_type" ]
    when "comment", "parsedcomment", "canonicaltitle", "metadata", "extmetadata"
      # TODO:not yet implemented.
    else
      warn "unknown property name: #{ prop }"
    end
  end
  result
end

if $0 == __FILE__
  cgi = CGI.new
  title = cgi[ "titles" ]
  imageinfo = make_imageinfo( title, cgi )
  #STDERR.puts imageinfo.inspect
  #STDERR.puts cgi.params.inspect
  data = {
    :query => {
      :pages => {
        :"-1" => {
	  :ns => 6,
	  :title => title,
	  :imagerepository => "local",
	  :imageinfo => [],
	}
      }
    }
  }
  data[:query][:pages][:"-1"][:imageinfo] << imageinfo
  cgi.out( "application/json" ) do
    JSON.generate( data )
  end
end
