require 'digest/sha1'

class User < ActiveRecord::Base
	validates_presence_of :email, :password, :password_confirmation
	validates_confirmation_of :password
	validates_uniqueness_of :email
	validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email address"
	
	attr_accessor :password, :password_confirmation
	
	def password=(pass)
		@password = pass
		self.hashed_password = User.encrypt(pass)
	end
	
	def authenticate(user, pass)
		u = find(:first, :conditions=>["login = ?", login])
		return nil if u.nil?
		return u if User.encrypt(pass) == u.password
		nil
	end
	
	def User.encrypt(pass)
		Digest::SHA1.hexdigest(pass)
	end
end
