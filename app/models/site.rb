require 'open-uri'
require 'feed-normalizer'
require 'rfeedfinder'
require 'getsongs'

class Site < ActiveRecord::Base
	@@CACHE_TIMEOUT = 1200
	has_many :songs, :dependent => :destroy
	validates_uniqueness_of :uri
	
	after_create :update_songs
	
	def get_songs
		if Time.new - self.last_polled > @@CACHE_TIMEOUT && GetSongs.getURILastModified(self.uri) > self.last_polled
			update_songs
		end
		songs
	end
	
	protected
	def update_songs
		self.update_attribute(:last_polled, Time.new)
		# want to fetch the uri and parse it looking for audio files
		# each found file should be added to the songs database
		songs = GetSongs.getSongsFromURI(self.uri)
		songs.each do |s|
			Song.create(:uri => s[:uri], :title => s[:title], :site_id => self.id)
		end
	end
end
