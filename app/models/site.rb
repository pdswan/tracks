require 'open-uri'
require 'feed-normalizer'
require 'rfeedfinder'
require 'getsongs'

class Site < ActiveRecord::Base
	has_many :song
	validates_uniqueness_of :uri
	
	after_create :update_songs
	
	protected
	def update_songs
		# want to fetch the uri and parse it looking for audio files
		# each found file should be added to the songs database
		songs = GetSongs.getSongsFromURI(self.uri)
		songs.each do |s|
			song_object = Song.create(:uri => s, :site_id => self.id)
			pp song_object
		end
	end
end
