class User < ActiveRecord::Base
  attr_accessible :first, :last, :dob, :address, :city, :zip, :contact_one,
                  :contact_one_primary, :contact_one_secondary, :contact_two,
                  :contact_two_primary, :contact_two_secondary, :email,
                  :gender, :skill, :extra, :password, :password_confirmation,
                  :access_code
                  
  has_secure_password 

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  before_save { |user| user.email = email.downcase }
  
  VALID_DOB_REGEX = /\A\d\d\/\d\d\/\d\d\d\d\z/
  VALID_PHONE_REGEX = /\A\(\d{3}\) \d{3}\-\d{4}\z/
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  VALID_ZIP_REGEX = /\A\d\d\d\d\d\z/
  VALID_GENDER_REGEX = /\A(male|female|other)\z/
  VALID_SKILL_REGEX = /\A(beginner|beggining strokes|intermediate|advanced)\z/
  validates :first, presence: true, length: { maximum: 32 }
  validates :last, presence: true, length: { maximum: 32 }
  validates :dob, format: { with: VALID_DOB_REGEX }
  validates :address, presence: true, length: { maximum: 32 }
  validates :city, presence: true, length: { maximum: 32 }
  validates :zip, format: { with: VALID_ZIP_REGEX }
  validates :contact_one, presence: true, length: { maximum: 32 }
  validates :contact_one_primary, format: { with: VALID_PHONE_REGEX }
  validates :contact_one_secondary, format: { with: VALID_PHONE_REGEX }
  validates :contact_two, presence: true, length: { maximum: 32 }
  validates :contact_two_primary, format: { with: VALID_PHONE_REGEX }
  validates :contact_two_secondary, format: { with: VALID_PHONE_REGEX }
  validates :email, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false } 
  validates :gender, format: { with: VALID_GENDER_REGEX } 
  validates :skill, format: { with: VALID_SKILL_REGEX }
  validates :extra, length: { maximum: 256 }
  validates :password, presence: true, length: { minimum: 6, maximum: 32 }
  validates :password_confirmation, presence: true

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
