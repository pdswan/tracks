class ChangeUserPasswordFieldName < ActiveRecord::Migration
  def self.up
    remove_column :users, :password
    add_column :users, :hashed_password, :string
  end

  def self.down
    remove_column :users, :hashed_password
    add_column :users, :password, :string
  end
end
