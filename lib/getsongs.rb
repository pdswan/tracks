#!/usr/bin/ruby

require('rubygems')
require('open-uri')
require('rfeedfinder')
require('feed-normalizer')
require('hpricot')

module GetSongs
	FILETYPES = ['mp3']
	# need to grab text from link and store it as the song title as well.
	REGEXP = Regexp.new('(?:<|&lt;)a href="(.+?\.(?:' + FILETYPES.join('|') + '))".*?>(.+?)</a>', true)
	
	def GetSongs.getSongObjectFromMatches(m)
		((m.length == 3) && {:uri => m[1], :title => m[2].gsub(/<\/?[^>]*>/, '').chomp}) || nil
	end
	
	def GetSongs.getSongsFromURI(uri, find_feed = true)
		songs = nil
		feeduri = find_feed && Rfeedfinder.feed(uri)
		if feeduri then
			#extract from feed
			feed = FeedNormalizer::FeedNormalizer.parse open(feeduri) 
			songs = feed.entries.map do |e|
				GetSongs.getSongObjectFromMatches(e.content.match(REGEXP).to_a)
			end.compact
		else
			#extract from html
			doc = Hpricot(open(uri))
			songs = doc.search('a').to_a.map do |a|
				GetSongs.getSongObjectFromMatches(a.to_html.match(REGEXP).to_a)
			end.compact
		end
		songs
	end
	
	def GetSongs.getURILastModified(uri, find_feed = true)
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
	songs = GetSongs.getSongsFromURI(uri, use_feed)
	songs.each do |s|
		p "uri: #{s[:uri]}, title: #{s[:title]}"
	end
	GetSongs.getURILastModified(uri, use_feed)
end