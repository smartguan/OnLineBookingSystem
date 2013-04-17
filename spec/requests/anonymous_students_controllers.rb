require 'spec_helper'

describe "AnonymousStudentsControllers" do
  #Capybara.javascript_driver = :webkit

  SUCCESS = 1 
  FIRST_NOT_VALID = 101
  LAST_NOT_VALID = 102
  EMAIL_NOT_VALID = 103
  PASS_NOT_VALID = 104
  PASS_NOT_MATCH = 109
  DOB_NOT_VALID = 105
  ADDRESS_NOT_VALID = 110
  CITY_NOT_VALID = 111
  ZIP_NOT_VALID = 106
  CONTACT_ONE_NOT_VALID = 112
  CONTACT_ONE_PRIMARY_NOT_VALID = 113
  CONTACT_ONE_SECONDARY_NOT_VALID = 113
  CONTACT_TWO_NOT_VALID = 114
  CONTACT_TWO_PRIMARY_NOT_VALID = 115
  CONTACT_TWO_SECONDARY_NOT_VALID = 116
  GENDER_NOT_VALID = 120
  SKILL_NOT_VALID = 118
  EXTRA_NOT_VALID = 119
  USER_EXISTS = 107
  BAD_CREDENTIALS = 108
  DEFAULT = 999

  before { @user_hash = { first: "first", last: "last", dob: "00/11/2222", 
                          residence: { address: "123 a st.", city: "b-town", 
                                       zip: "12345" },
                          contacts: { first: { name: "mom", 
                                               primary: "(123) 456-7890",
                                               secondary: "(098) 765-4321" },
                                      second: { name: "dad", 
                                                primary: "(123) 456-7890",
                                                secondary: "(098) 765-4321" } },
                          email: "abc@def.org",
                          gender: "other", skill: "intermediate",
                          extra: "This is extra info",
                          format: :json } }

  describe "when adding a valid user" do
    it "should create a user" do
      expect { post "/AnonymousStudents/add", @user_hash }.to change(AnonymousStudent, :count).by(1)
    end
  end

  describe "when adding a valid user" do
    it "should return SUCCESS" do
      expected = SUCCESS
      post '/AnonymousStudents/add', @user_hash  
      parsed_body = JSON.parse(response.body)
      parsed_body["errCode"].should == expected
    end
  end

  describe "when adding a user with first blank" do
    it "should return FIRST_NOT_VALID" do
      expected = { errCode: FIRST_NOT_VALID }.to_json
      @user_hash[:first] = "" 
      post '/AnonymousStudents/add', @user_hash 
      response.body.should == expected
    end
  end

  describe "when adding a user with last blank" do
    it "should return LAST_NOT_VALID" do
      expected = { errCode: LAST_NOT_VALID }.to_json
      @user_hash[:last] = "" 
      post '/AnonymousStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with address blank" do
    it "should return ADDRESS_NOT_VALID" do
      expected = { errCode: ADDRESS_NOT_VALID }.to_json
      @user_hash[:residence][:address] = "" 
      post '/AnonymousStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with city blank" do
    it "should return CITY_NOT_VALID" do
      expected = { errCode: CITY_NOT_VALID }.to_json
      @user_hash[:residence][:city] = "" 
      post '/AnonymousStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with zip blank" do
    it "should return ZIP_NOT_VALID" do
      expected = { errCode: ZIP_NOT_VALID }.to_json
      @user_hash[:residence][:zip] = "" 
      post '/AnonymousStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact one blank" do
    it "should return CONTACT_ONE_NOT_VALID" do
      expected = { errCode: CONTACT_ONE_NOT_VALID }.to_json
      @user_hash[:contacts][:first][:name] = "" 
      post '/AnonymousStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact one primary blank" do
    it "should return CONTACT_ONE_PRIMARY_NOT_VALID" do
      expected = { errCode: CONTACT_ONE_PRIMARY_NOT_VALID }.to_json
      @user_hash[:contacts][:first][:primary] = "" 
      post '/AnonymousStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact one secondary blank" do
    it "should return CONTACT_ONE_SECONDARY_NOT_VALID" do
      expected = { errCode: CONTACT_ONE_SECONDARY_NOT_VALID }.to_json
      @user_hash[:contacts][:first][:secondary] = "" 
      post '/AnonymousStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact two blank" do
    it "should return CONTACT_TWO_NOT_VALID" do
      expected = { errCode: CONTACT_TWO_NOT_VALID }.to_json
      @user_hash[:contacts][:second][:name] = "" 
      post '/AnonymousStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact two primary blank" do
    it "should return CONTACT_TWO_PRIMARY_NOT_VALID" do
      expected = { errCode: CONTACT_TWO_PRIMARY_NOT_VALID }.to_json
      @user_hash[:contacts][:second][:primary] = "" 
      post '/AnonymousStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact two secondary blank" do
    it "should return CONTACT_TWO_SECONDARY_NOT_VALID" do
      expected = { errCode: CONTACT_TWO_SECONDARY_NOT_VALID }.to_json
      @user_hash[:contacts][:second][:secondary] = "" 
      post '/AnonymousStudents/add', @user_hash  
      response.body.should == expected
    end
  end

  describe "when adding a user with invalid email" do
    it "should return EMAIL_NOT_VALID" do
      expected = { errCode: EMAIL_NOT_VALID }.to_json
      @user_hash[:email] = "invalid email"
      post '/AnonymousStudents/add', @user_hash
      response.body.should == expected
    end
  end

  describe "when adding a user with a taken email" do
    it "should return USER_EXISTS" do
      expected = { errCode: USER_EXISTS }.to_json
      temp_user = FactoryGirl.create(:member_student) 
      @user_hash[:email] = temp_user.email
      post '/AnonymousStudents/add', @user_hash
      response.body.should == expected
    end
  end
  
  describe "when adding a user with gender blank" do
    it "should return GENDER_NOT_VALID" do
      expected = { errCode: GENDER_NOT_VALID }.to_json
      @user_hash[:gender] = "bat"
      post '/AnonymousStudents/add', @user_hash
      response.body.should == expected
    end
  end
  
  describe "when adding a user with skill blank" do
    it "should return SKILL_NOT_VALID" do
      expected = { errCode: SKILL_NOT_VALID }.to_json
      @user_hash[:skill] = "gifted"
      post '/AnonymousStudents/add', @user_hash
      response.body.should == expected
    end
  end
  
  describe "when adding a user with extra too long" do
    it "should return EXTRA_NOT_VALID" do
      expected = { errCode: EXTRA_NOT_VALID }.to_json
      @user_hash[:extra] = "a" * 257
      post '/AnonymousStudents/add', @user_hash
      response.body.should == expected
    end
  end
end
