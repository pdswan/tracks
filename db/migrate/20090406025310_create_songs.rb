class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :uri

      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
