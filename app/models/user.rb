class User < ActiveRecord::Base
	attr_accessible :first_name, :last_name, :username, 
									:email, :email_confirmation, :password, :password_confirmation,
									:is_artist, :preferences, :terms, :city, :custom_city
	serialize :oauth_token
#	has_secure_password
	has_one :artist

#	before_save { |user| user.email = email.downcase }
#	before_save :create_remember_token

#	validates :first_name, :presence => true, :length => {:maximum => 25}
#	validates :last_name, :length => {:maximum => 30}
#	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
#	validates :email, :presence => true, :length => {:maximum => 25}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
#	validates :email_confirmation, presence: true
#	validate :check_email_and_confirmation
#	validates :username, :presence => true, :length => {:minimum =>8, :maximum => 16}
#	validates :password, presence: true, length: { minimum: 6 }
#  validates :password_confirmation, presence: true
#	

#	def check_email_and_confirmation
#		if (self.email != self.email_confirmation)
#			errors.add(:email, "Make sure the email address you typed is correct")
#		end
#	end

#	private

#		def create_remember_token
#		  self.remember_token = SecureRandom.urlsafe_base64
#		end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.username = auth.extra.raw_info.username
			user.email = auth.info.email
      user.oauth_token = auth.credentials
			if !user.custom_city
				user.city = auth.info.location
			end
      user.save!
    end
  end

end


