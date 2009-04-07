#!/usr/bin/ruby

require('rubygems')
require('open-uri')
require('rfeedfinder')
require('feed-normalizer')
require('hpricot')

module GetSongs
	FILETYPES = ['mp3']
	REGEXP = Regexp.new('(?:<|&lt;)a href="(.+?\.(?:' + FILETYPES.join('|') + '))"')
	
	def GetSongs.getSongsFromURI(uri, find_feed = true)
		songs = nil
		feeduri = find_feed && Rfeedfinder.feed(uri)
		if feeduri then
			#extract from feed
			feed = FeedNormalizer::FeedNormalizer.parse open(feeduri) 
			songs = feed.entries.map {|e| e.content.match(REGEXP).to_a.reject {|f| f.match(/</)}}.flatten.compact
		else
			#extract from html
			doc = Hpricot(open(uri))
			songs = doc.search("a").to_a.map {|a| a.to_html.match(REGEXP)[1] rescue nil}.compact
		end
		songs
	end
	
	def GetSongs.getURILastModified(uri, find_feed)
		uri = (find_feed && Rfeedfinder.feed(uri)) || uri
		f = open(uri)
		pp f.meta
		f.last_modified || Time.httpdate(f.meta['date'])
	end
end

if __FILE__ == $0
	begin
		uri = ARGV[0]
		use_feed = ARGV[1].match(/^(true|t|yes|y|1)$/i) != nil rescue true
	rescue
		raise "usage: getsongs.rb <uri> <use_feed>"
	end
	p "uri: #{uri}"
	p "regexp: #{GetSongs::REGEXP}"
	p GetSongs.getSongsFromURI(uri, use_feed)
	p GetSongs.getURILastModified(uri, use_feed)
end