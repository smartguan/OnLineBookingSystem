class User < ActiveRecord::Base
  attr_accessible :admin, :dob, :email, :first, :last, :zip, :password, :password_confirmation
  has_secure_password 

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :first, presence: true, length: { maximum: 32 }
  validates :last, presence: true, length: { maximum: 32 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false } 
  VALID_DOB_REGEX = /\A\d\d\/\d\d\/\d\d\d\d\z/
  validates :dob, format: { with: VALID_DOB_REGEX }
  VALID_ZIP_REGEX = /\A\d\d\d\d\d\z/
  validates :zip, format: { with: VALID_ZIP_REGEX }
  validates :password, presence: true, length: { minimum: 6, maximum: 32 }
  validates :password_confirmation, presence: true

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
