class AddLastRequestAtToUser < ActiveRecord::Migration
  def self.up
  	add_column :users, :last_request_at, :date_time
  end

  def self.down
  	remove_column :users, :last_request_at
  end
end
