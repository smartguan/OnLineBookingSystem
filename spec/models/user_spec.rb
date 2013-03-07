require 'spec_helper'

describe User do

  before { @user = User.new(first: "first", last: "last", email: "abc@def.com", dob: "01/02/0003", zip: "12345", admin: 0, password: "password", password_confirmation: "password") }

  subject { @user }

  it { should respond_to(:first) }
  it { should respond_to(:last) }
  it { should respond_to(:email) }
  it { should respond_to(:dob) }
  it { should respond_to(:zip) }
  it { should respond_to(:admin) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid }

  describe "when first is blank" do
    before { @user.first = " " }
    it { should_not be_valid }
  end

  describe "when last is blank" do
    before { @user.last = " " }
    it { should_not be_valid }
  end

  describe "when email is blank" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when dob is blank" do
    before { @user.dob = " " }
    it { should_not be_valid }
  end

  describe "when zip is blank" do
    before { @user.zip = " " }
    it { should_not be_valid }
  end
  
  describe "when password is blank" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when first is too long" do
    before { @user.first = "a" * 33 }
    it { should_not be_valid }
  end

  describe "when last is too long" do
    before { @user.last = "a" * 33 }
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

  describe "when zip is invalid" do
    it "should be invalid" do
      codes = %w[1234 123456 12345-7890]
      codes.each do |invalid_code|
        @user.zip = invalid_code
        @user.should_not be_valid
      end
    end
  end

  describe "when zip is valid" do
    it "should be valid" do
      valid_code = "12345"
      @user.zip = valid_code
      @user.should be_valid
    end
  end

  describe "when admin is 0" do
    it "should be false" do
      bool = 0 
      @user.admin = bool
      expect(@user.admin).to eq(false)
    end
  end
  
  describe "when admin is 1" do
    it "should be true" do
      bool = 1 
      @user.admin = bool
      expect(@user.admin).to eq(true)
    end
  end
  
  describe "when admin is anything besides 1 or 0" do
    it "should be false" do
      bool = "abc" 
      @user.admin = bool
      expect(@user.admin).to eq(false)
    end
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
end
