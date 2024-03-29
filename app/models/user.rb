class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
	attr_accessible :first_name, :last_name, :username, 
									:email, :email_confirmation, :password, :password_confirmation,
									:is_artist, :fb_meta, :user_meta, :terms, :city, :custom_city,
									:song_history, :invites, :favorite_songs
	serialize :oauth_token
	serialize :fb_meta
	serialize :user_meta
	serialize :song_history
	serialize :invites
	serialize :favorite_songs
#	has_secure_password
	has_one :artist, dependent: :destroy
	has_many :reports #Allow user to report others

#	before_save { |user| user.email = email.downcase }
#	before_save :create_remember_token

#	validates :first_name, :presence => true, :length => {:maximum => 25}
#	validates :last_name, :length => {:maximum => 30}
#	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
#	validates :email, :presence => true, :length => {:maximum => 25}, format: { with: VALID_EMAIL_REGEX }, uniqueness: {case_sensitive: false}
	validates :email, confirmation: true
	# validate :check_email_and_confirmation
#	validates :username, :presence => true, :length => {:minimum =>8, :maximum => 16}
#	validates :password, presence: true, length: { minimum: 6 }
#  validates :password_confirmation, presence: true
#	

	def check_email_and_confirmation
		if (self.email.downcase != self.email_confirmation.downcase)
			errors.add(:email, "Make sure the email address you typed is correct")
		end
	end

#	private

#		def create_remember_token
#		  self.remember_token = SecureRandom.urlsafe_base64
#		end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      # user.provider = auth.provider
      # user.uid = auth.uid
      user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.username = auth.extra.raw_info.username
			user.email = auth.info.email
			user.password = Devise.friendly_token[0,20]
      user.oauth_token = auth.credentials
			koala_oauth = Koala::Facebook::OAuth.new(ENV["FACEBOOK_APP_ID"],ENV["FACEBOOK_SECRET"])
			user.oauth_token['extended_token'] = koala_oauth.exchange_access_token_info(user.oauth_token.token)
			if !user.city
				user.city = auth.info.location
				user.city_coords = Geocoder.coordinates(user.city).join(",") if !user.city.nil? && user.city != ''
			end
      user.save!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

end


