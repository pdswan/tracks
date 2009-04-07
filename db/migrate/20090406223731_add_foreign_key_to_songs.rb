class AddForeignKeyToSongs < ActiveRecord::Migration
  def self.up
    add_column :songs, :site_id, :integer
  end

  def self.down
    remove_column :songs, :site_id
  end
end
