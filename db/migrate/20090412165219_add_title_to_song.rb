class AddTitleToSong < ActiveRecord::Migration
  def self.up
  	add_column :songs, :title, :string
  end

  def self.down
  	remove_column :songs, :title
  end
end
