require 'spec_helper'

describe "MemberStudentsControllers" do
  # Error Codes located in spec_helper.rb

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
                          password: "password",
                          password_confirmation: "password",
                          format: :json } }

  # MemberStudents/add 
  describe "when adding a valid user" do
    it "should create a user" do
      expect { post "/MemberStudents/add", @user_hash }.to change(MemberStudent, :count).by(1)
    end
  end

  describe "when adding a valid user" do
    it "should return SUCCESS" do
      expected = { errCode: SUCCESS }.to_json
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end

  describe "when adding a user with first blank" do
    it "should return FIRST_NOT_VALID" do
      expected = { errCode: FIRST_NOT_VALID }.to_json
      @user_hash[:first] = "" 
      post '/MemberStudents/add', @user_hash 
      response.body.should == expected
    end
  end

  describe "when adding a user with last blank" do
    it "should return LAST_NOT_VALID" do
      expected = { errCode: LAST_NOT_VALID }.to_json
      @user_hash[:last] = "" 
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with address blank" do
    it "should return ADDRESS_NOT_VALID" do
      expected = { errCode: ADDRESS_NOT_VALID }.to_json
      @user_hash[:residence][:address] = "" 
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with city blank" do
    it "should return CITY_NOT_VALID" do
      expected = { errCode: CITY_NOT_VALID }.to_json
      @user_hash[:residence][:city] = "" 
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with zip blank" do
    it "should return ZIP_NOT_VALID" do
      expected = { errCode: ZIP_NOT_VALID }.to_json
      @user_hash[:residence][:zip] = "" 
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact one blank" do
    it "should return CONTACT_ONE_NOT_VALID" do
      expected = { errCode: CONTACT_ONE_NOT_VALID }.to_json
      @user_hash[:contacts][:first][:name] = "" 
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact one primary blank" do
    it "should return CONTACT_ONE_PRIMARY_NOT_VALID" do
      expected = { errCode: CONTACT_ONE_PRIMARY_NOT_VALID }.to_json
      @user_hash[:contacts][:first][:primary] = "" 
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact one secondary blank" do
    it "should return CONTACT_ONE_SECONDARY_NOT_VALID" do
      expected = { errCode: CONTACT_ONE_SECONDARY_NOT_VALID }.to_json
      @user_hash[:contacts][:first][:secondary] = "" 
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact two blank" do
    it "should return CONTACT_TWO_NOT_VALID" do
      expected = { errCode: CONTACT_TWO_NOT_VALID }.to_json
      @user_hash[:contacts][:second][:name] = "" 
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact two primary blank" do
    it "should return CONTACT_TWO_PRIMARY_NOT_VALID" do
      expected = { errCode: CONTACT_TWO_PRIMARY_NOT_VALID }.to_json
      @user_hash[:contacts][:second][:primary] = "" 
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end
  
  describe "when adding a user with contact two secondary blank" do
    it "should return CONTACT_TWO_SECONDARY_NOT_VALID" do
      expected = { errCode: CONTACT_TWO_SECONDARY_NOT_VALID }.to_json
      @user_hash[:contacts][:second][:secondary] = "" 
      post '/MemberStudents/add', @user_hash  
      response.body.should == expected
    end
  end

  describe "when adding a user with invalid email" do
    it "should return EMAIL_NOT_VALID" do
      expected = { errCode: EMAIL_NOT_VALID }.to_json
      @user_hash[:email] = "invalid email"
      post '/MemberStudents/add', @user_hash
      response.body.should == expected
    end
  end

  describe "when adding a user with a taken email" do
    it "should return USER_EXISTS" do
      expected = { errCode: USER_EXISTS }.to_json
      temp_user = FactoryGirl.create(:member_student) 
      @user_hash[:email] = temp_user.email
      post '/MemberStudents/add', @user_hash
      response.body.should == expected
    end
  end
  
  describe "when adding a user with gender blank" do
    it "should return GENDER_NOT_VALID" do
      expected = { errCode: GENDER_NOT_VALID }.to_json
      @user_hash[:gender] = "bat"
      post '/MemberStudents/add', @user_hash
      response.body.should == expected
    end
  end
  
  describe "when adding a user with skill blank" do
    it "should return SKILL_NOT_VALID" do
      expected = { errCode: SKILL_NOT_VALID }.to_json
      @user_hash[:skill] = "gifted"
      post '/MemberStudents/add', @user_hash
      response.body.should == expected
    end
  end
  
  describe "when adding a user with extra too long" do
    it "should return EXTRA_NOT_VALID" do
      expected = { errCode: EXTRA_NOT_VALID }.to_json
      @user_hash[:extra] = "a" * 257
      post '/MemberStudents/add', @user_hash
      response.body.should == expected
    end
  end

  describe "when adding a user with blank password" do
    it "should return PASS_NOT_VALID" do
      expected = { errCode: PASS_NOT_VALID }.to_json
      @user_hash[:password] = ""
      @user_hash[:password_confirmation] = ""
      post '/MemberStudents/add', @user_hash
      response.body.should == expected
    end
  end
  
  describe "when adding a user when password and password_confirmation don't match" do
    it "should return PASS_NOT_MATCH" do
      expected = { errCode: PASS_NOT_MATCH }.to_json
      @user_hash[:password] = "password"
      @user_hash[:password_confirmation] = "passwerd"
      post '/MemberStudents/add', @user_hash
      response.body.should == expected
    end
  end
end
