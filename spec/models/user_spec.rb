require 'spec_helper'

describe User do

  before do
    @user = FactoryGirl.build(:user) 
  end

  subject { @user }

  it { should respond_to(:first) }
  it { should respond_to(:last) }
  it { should respond_to(:email) }
  it { should respond_to(:dob) }
  it { should respond_to(:address) }
  it { should respond_to(:city) }
  it { should respond_to(:zip) }
  it { should respond_to(:contact_one) }
  it { should respond_to(:contact_one_primary) }
  it { should respond_to(:contact_one_secondary) }
  it { should respond_to(:contact_two) }
  it { should respond_to(:contact_two_primary) }
  it { should respond_to(:contact_two_secondary) }
  it { should respond_to(:gender) }
  it { should respond_to(:skill) }
  it { should respond_to(:extra) }
  it { should respond_to(:access_code) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }

  describe "when first is blank" do
    before { @user.first = " " }
    it { should_not be_valid }
  end

  describe "when first is too long" do
    before { @user.first = "a" * 33 }
    it { should_not be_valid }
  end

  describe "when last is blank" do
    before { @user.last = " " }
    it { should_not be_valid }
  end
  
  describe "when last is too long" do
    before { @user.last = "a" * 33 }
    it { should_not be_valid }
  end

  describe "when email is blank" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end 

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end 

  describe "when dob is blank" do
    before { @user.dob = " " }
    it { should_not be_valid }
  end
  
  describe "when dob format is invalid" do
    it "should be invalid" do
      births = %w[1/02/1234 01/2/1234 01/02/34 1/2/34 001/02/12349 01-12-1234]
      births.each do |invalid_birth|
        @user.dob = invalid_birth
        @user.should_not be_valid
      end
    end
  end
  
  describe "when dob format is valid" do
    it "should be valid" do
      valid_birth = "01/02/1234" 
      @user.dob = valid_birth
      @user.should be_valid
    end
  end

  describe "when address is blank" do
    before { @user.address = " " }
    it { should_not be_valid }
  end
  
  describe "when address is too long" do
    it "should be invalid" do
      @user.address = "a" * 33 
      @user.should_not be_valid
    end
  end
  
  describe "when city is blank" do
    before { @user.city = " " }
    it { should_not be_valid }
  end
  
  describe "when city is too long" do
    it "should be invalid" do
      @user.city = "a" * 33 
      @user.should_not be_valid
    end
  end

  describe "when zip is blank" do
    before { @user.zip = " " }
    it { should_not be_valid }
  end
  
  describe "when zip is invalid" do
    it "should be invalid" do
      codes = %w[1234 123456 12345-7890]
      codes.each do |invalid_code|
        @user.zip = invalid_code
        @user.should_not be_valid
      end
    end
  end

  describe "when contact_one is blank" do
    before { @user.contact_one = " " }
    it { should_not be_valid }
  end
  
  describe "when contact_one is too long" do
    it "should be invalid" do
      @user.contact_one = "a" * 33
      @user.should_not be_valid
    end
  end

  describe "when contact_one_primary is blank" do
    before { @user.contact_one_primary = " " }
    it { should_not be_valid }
  end
  
  describe "when contact_one_primary is the wrong format" do
    it "should be invalid" do
      numbers = %w[(0123)456-7890 11234567890 invalidphonenumber]
      numbers.each do |invalid_code|
        @user.contact_one_primary = invalid_code
        @user.should_not be_valid
      end
    end
  end

  describe "when contact_one_secondary is blank" do
    before { @user.contact_two_primary = " " }
    it { should_not be_valid }
  end
  
  describe "when contact_one_secondary is the wrong format" do
    it "should be invalid" do
      numbers = %w[(0123)456-7890 11234567890 invalidphonenumber]
      numbers.each do |invalid_code|
        @user.contact_one_secondary = invalid_code
        @user.should_not be_valid
      end
    end
  end

  describe "when contact_two is blank" do
    before { @user.contact_two = " " }
    it { should_not be_valid }
  end
  
  describe "when contact_two is too long" do
    it "should be invalid" do
      @user.contact_two = "a" * 33
      @user.should_not be_valid
    end
  end

  describe "when contact_two_primary is blank" do
    before { @user.contact_two_primary = " " }
    it { should_not be_valid }
  end
 
  describe "when contact_two_primary is the wrong format" do
    it "should be invalid" do
      numbers = %w[(0123)456-7890 11234567890 invalidphonenumber]
      numbers.each do |invalid_code|
        @user.contact_two_primary = invalid_code
        @user.should_not be_valid
      end
    end
  end
 
  describe "when contact_two_secondary is blank" do
    before { @user.contact_two_secondary = " " }
    it { should_not be_valid }
  end
  
  describe "when contact_two_secondary is the wrong format" do
    it "should be invalid" do
      numbers = %w[(0123)456-7890 11234567890 invalidphonenumber]
      numbers.each do |invalid_code|
        @user.contact_two_secondary = invalid_code
        @user.should_not be_valid
      end
    end
  end

  describe "when gender is blank" do
    before { @user.gender = " " }
    it { should_not be_valid }
  end
  
  describe "when gender is invalid" do
    it "should be inalid" do
      @user.gender = "dog"
      @user.should_not be_valid
    end
  end

  describe "when skill is blank" do
    before { @user.skill = " " }
    it { should_not be_valid }
  end
  
  describe "when skill is invalid" do
    it "should be inavlid" do
      @user.skill = "bad"
      @user.should_not be_valid
    end
  end

  describe "when password is blank" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end
  
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { @user.password = "short" }
    it { should_not be_valid }
  end

  describe "when password is too long" do
    before { @user.password = "a" * 33 }
    it { should_not be_valid }
  end

  describe "when extra is too long" do
    it "should be invalid" do
      @user.extra = "a" * 257
      @user.should_not be_valid
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end
end
