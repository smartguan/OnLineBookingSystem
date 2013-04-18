require 'spec_helper'

describe "AdminControllers" do
  #Capybara.javascript_driver = :webkit

#  SUCCESS = 1 
#  FIRST_NOT_VALID = 101
#  LAST_NOT_VALID = 102
#  EMAIL_NOT_VALID = 103
#  PASS_NOT_VALID = 104
#  PASS_NOT_MATCH = 109
#  DOB_NOT_VALID = 105
#  ADDRESS_NOT_VALID = 110
#  CITY_NOT_VALID = 111
#  ZIP_NOT_VALID = 106
#  CONTACT_ONE_NOT_VALID = 112
#  CONTACT_ONE_PRIMARY_NOT_VALID = 113
#  CONTACT_ONE_SECONDARY_NOT_VALID = 113
#  CONTACT_TWO_NOT_VALID = 114
#  CONTACT_TWO_PRIMARY_NOT_VALID = 115
#  CONTACT_TWO_SECONDARY_NOT_VALID = 116
#  GENDER_NOT_VALID = 120
#  SKILL_NOT_VALID = 118
#  EXTRA_NOT_VALID = 119
#  USER_EXISTS = 107
#  BAD_CREDENTIALS = 108
#  DEFAULT = 999

  before do 
    FactoryGirl.create(:admin)
    post '/Users/login', { email: "admin@admin.org", password: "password",
                           format: :json }
    @user_hash = { first: "first", last: "last", dob: "00/11/2222", 
                   residence: { address: "123 a st.", city: "b-town", 
                                zip: "12345" },
                   contacts: { first: { name: "mom", 
                                        primary: "(123) 456-7890",
                                        secondary: "(098) 765-4321" } },
                   email: "abc@def.org",
                   password: "password",
                   password_confirmation: "password",
                   format: :json }
  end

  # Testing Admin/addInstructor
  describe "when adding a valid user" do
    it "should create a user" do
      expect { post "/Admin/addInstructor", @user_hash }.to change(Instructor, :count).by(1)
    end
  end

  describe "when adding a valid user" do
    it "should return SUCCESS" do
      expected = { errCode: SUCCESS }.to_json
      post '/Admin/addInstructor', @user_hash  
      response.body.should == expected
    end
  end

  describe "when adding a user with first blank" do
    it "should return FIRST_NOT_VALID" do
      expected = { errCode: FIRST_NOT_VALID }.to_json
      @user_hash[:first] = "" 
      post '/Admin/addInstructor', @user_hash 
      response.body.should == expected
    end
  end

  describe "when adding a user with last blank" do
    it "should return LAST_NOT_VALID" do
      expected = { errCode: LAST_NOT_VALID }.to_json
      @user_hash[:last] = "" 
      post '/Admin/addInstructor', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with address blank" do
    it "should return ADDRESS_NOT_VALID" do
      expected = { errCode: ADDRESS_NOT_VALID }.to_json
      @user_hash[:residence][:address] = "" 
      post '/Admin/addInstructor', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with city blank" do
    it "should return CITY_NOT_VALID" do
      expected = { errCode: CITY_NOT_VALID }.to_json
      @user_hash[:residence][:city] = "" 
      post '/Admin/addInstructor', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with zip blank" do
    it "should return ZIP_NOT_VALID" do
      expected = { errCode: ZIP_NOT_VALID }.to_json
      @user_hash[:residence][:zip] = "" 
      post '/Admin/addInstructor', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact one blank" do
    it "should return CONTACT_ONE_NOT_VALID" do
      expected = { errCode: CONTACT_ONE_NOT_VALID }.to_json
      @user_hash[:contacts][:first][:name] = "" 
      post '/Admin/addInstructor', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact one primary blank" do
    it "should return CONTACT_ONE_PRIMARY_NOT_VALID" do
      expected = { errCode: CONTACT_ONE_PRIMARY_NOT_VALID }.to_json
      @user_hash[:contacts][:first][:primary] = "" 
      post '/Admin/addInstructor', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact one secondary blank" do
    it "should return CONTACT_ONE_SECONDARY_NOT_VALID" do
      expected = { errCode: CONTACT_ONE_SECONDARY_NOT_VALID }.to_json
      @user_hash[:contacts][:first][:secondary] = "" 
      post '/Admin/addInstructor', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with invalid email" do
    it "should return EMAIL_NOT_VALID" do
      expected = { errCode: EMAIL_NOT_VALID }.to_json
      @user_hash[:email] = "invalid email"
      post '/Admin/addInstructor', @user_hash
      response.body.should == expected
    end
  end

  describe "when adding a user with a taken email" do
    it "should return USER_EXISTS" do
      expected = { errCode: USER_EXISTS }.to_json
      temp_user = FactoryGirl.create(:member_student) 
      @user_hash[:email] = temp_user.email
      post '/Admin/addInstructor', @user_hash
      response.body.should == expected
    end
  end
  
  describe "when adding a user with blank password" do
    it "should return PASS_NOT_VALID" do
      expected = { errCode: PASS_NOT_VALID }.to_json
      @user_hash[:password] = ""
      @user_hash[:password_confirmation] = ""
      post '/Admin/addInstructor', @user_hash
      response.body.should == expected
    end
  end
  
  describe "when adding a user when password and password_confirmation don't match" do
    it "should return PASS_NOT_MATCH" do
      expected = { errCode: PASS_NOT_MATCH }.to_json
      @user_hash[:password] = "password"
      @user_hash[:password_confirmation] = "passwerd"
      post '/Admin/addInstructor', @user_hash
      response.body.should == expected
    end
  end

  # Testing Admin/delete
  describe "when deleting a member student" do
    it "should decrease member student count" do
      FactoryGirl.create(:member_student)
      expect { post 'Admin/delete', 
              { email: "abc@def.org", 
                format: :json } }.to change(MemberStudent, :count).by(-1)
    end
  end
  
  describe "when deleting a member student who doesn't exist" do
    it "should return BAD_CREDENTIALS" do
      expected = { errCode: BAD_CREDENTIALS }.to_json
      post '/Admin/delete', { email: "abc@def.org", format: :json }
      response.body.should == expected
    end
  end

  describe "when deleting an anonymous student" do
    it "should decrease anonymous student count" do
      FactoryGirl.create(:anonymous_student)
      expect { post 'Admin/delete', 
              { email: "abc@def.org", 
                format: :json } }.to change(AnonymousStudent, :count).by(-1)
    end
  end
  
  describe "when deleting a member student who doesn't exist" do
    it "should return BAD_CREDENTIALS" do
      expected = { errCode: BAD_CREDENTIALS }.to_json
      post '/Admin/delete', { email: "abc@def.org", format: :json }
      response.body.should == expected
    end
  end
  
  describe "when deleting an instructor" do
    it "should decrease instructor count" do
      FactoryGirl.create(:instructor)
      expect { post 'Admin/delete', 
              { email: "abc@def.org", 
                format: :json } }.to change(Instructor, :count).by(-1)
    end
  end
  
  describe "when deleting an instructor who doesn't exist" do
    it "should return BAD_CREDENTIALS" do
      expected = { errCode: BAD_CREDENTIALS }.to_json
      post '/Admin/delete', { email: "abc@def.org", format: :json }
      response.body.should == expected
    end
  end
end
