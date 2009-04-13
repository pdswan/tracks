class Song < ActiveRecord::Base
	belongs_to :site
	has_and_belongs_to_many :playlists
	validates_uniqueness_of :uri, :scope => :site_id
end
