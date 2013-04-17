require 'spec_helper'

describe "UsersControlers" do
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

  #Login functionality
  describe "when logging in with valid email" do
    it "should return SUCCESS and type" do
      FactoryGirl.create(:instructor)
      expected = { errCode: SUCCESS, type: "Instructor" }.to_json
      post '/Users/login', { email: "abc@def.org", password: "password", 
                             format: :json }
      response.body.should == expected
    end
  end
  
  describe "when logging in with invalid password" do
    it "should return BAD_CREDENTIALS" do
      FactoryGirl.create(:instructor)
      expected = { errCode: BAD_CREDENTIALS }.to_json
      post '/Users/login', { email: "abc@def.org", password: "passwerd", 
                             format: :json }
      response.body.should == expected
    end
  end
  
  describe "when logging in with invalid email" do
    it "should return BAD_CREDENTIALS" do
      expected = { errCode: BAD_CREDENTIALS }.to_json
      post '/Users/login', { email: "abc@def.org", password: "password", 
                             format: :json }
      response.body.should == expected
    end
  end

  describe "when logging out with valid user" do
    it "should return SUCCESS" do
      FactoryGirl.create(:instructor)
      expected = { errCode: SUCCESS }.to_json
      post '/Users/login', { email: "abc@def.org", password: "password", 
                             format: :json }
      post '/Users/logout', { format: :json }
      response.body.should == expected
    end
  end
  
  describe "when logging out with non signed in user" do
    it "should return BAD_CREDENTIALS" do
      expected = { errCode: BAD_CREDENTIALS }.to_json
      post '/Users/logout', { format: :json }
      response.body.should == expected
    end
  end

  #Profile Functionality
  describe "when requesting a profile with a valid user" do
    it "should return SUCCESS" do
      FactoryGirl.create(:member_student)
      expected = SUCCESS 
      post '/Users/login', { email: "abc@def.org", password: "password",
                             format: :json }
      post '/Users/profile', { format: :json }
      parsed_body = JSON.parse(response.body)
      parsed_body["errCode"].should == expected
    end
  end
  
  describe "when requesting a profile with a valid user" do
    it "should have correct format" do
      FactoryGirl.create(:member_student)
      expected = { "address" => "123 a st.", "city" => "b-town", 
                   "zip" => "12345" }
      post '/Users/login', { email: "abc@def.org", password: "password",
                             format: :json }
      post '/Users/profile', { format: :json }
      parsed_body = JSON.parse(response.body)
      parsed_body["user"]["residence"].should == expected
    end
  end

  describe "when requesting a proflie with an invalid user" do
    it "should return BAD_CREDENTIALS" do
      expected = BAD_CREDENTIALS
      post '/Users/profile', { format: :json }
      parsed_body = JSON.parse(response.body)
      parsed_body["errCode"].should == expected
    end
  end

  #Update Password Functionality
  describe "when updating the password of a valid user" do
    it "should return SUCCESS" do
      FactoryGirl.create(:member_student)
      expected = { errCode: SUCCESS }.to_json
      post '/Users/login', { email: "abc@def.org", password: "password",
                             format: :json }
      post '/Users/updatePassword', { password: "password",
                                      new_password: "new_password",
                                      new_password_confirmation: "new_password",
                                      format: :json }
      response.body.should == expected
    end
  end
  
  describe "when updating the password of a valid user, but new password is invalid" do
    it "should return PASS_NOT_VALID" do
      FactoryGirl.create(:member_student)
      expected = { errCode: PASS_NOT_VALID }.to_json
      post '/Users/login', { email: "abc@def.org", password: "password",
                             format: :json }
      post '/Users/updatePassword', { password: "password",
                                      new_password: "new",
                                      new_password_confirmation: "new",
                                      format: :json }
      response.body.should == expected
    end
  end
  
  describe "when updating the password of a valid user, but new password and new password confirmation don't match" do
    it "should return PASS_NOT_MATCH" do
      FactoryGirl.create(:member_student)
      expected = { errCode: PASS_NOT_MATCH }.to_json
      post '/Users/login', { email: "abc@def.org", password: "password",
                             format: :json }
      post '/Users/updatePassword', { password: "password",
                                      new_password: "new_password",
                                      new_password_confirmation: "new_passwerd",
                                      format: :json }
      response.body.should == expected
    end
  end
  
  describe "when updating the password of an invalid user" do
    it "should return BAD_CREDENTIALS" do
      expected = { errCode: BAD_CREDENTIALS }.to_json
      post '/Users/updatePassword', { password: "password",
                                      new_password: "new_password",
                                      new_password_confirmation: "new_passwerd",
                                      format: :json }
      response.body.should == expected
    end
  end

  #Update Functionality
  describe "when updating a user" do
    before do
      FactoryGirl.create(:member_student)
      post '/Users/login', { email: "abc@def.org", password: "password",
                             format: :json }
      @user_hash = { first: "first", last: "last", dob: "00/11/2222", 
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
                     format: :json }
    end
    
    describe "when updating a valid user with a wrong password" do
      it "should return BAD_CREDENTIALS" do
        expected = { errCode: BAD_CREDENTIALS }.to_json
        @user_hash[:password] = "passwerd" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end
    
    describe "when updating a valid user" do
      it "should return SUCCESS" do
        expected = { errCode: SUCCESS }.to_json
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end

    describe "when updating a user with first blank" do
      it "should return FIRST_NOT_VALID" do
        expected = { errCode: FIRST_NOT_VALID }.to_json
        @user_hash[:first] = "" 
        post '/Users/update', @user_hash 
        response.body.should == expected
      end
    end

    describe "when updating a user with last blank" do
      it "should return LAST_NOT_VALID" do
        expected = { errCode: LAST_NOT_VALID }.to_json
        @user_hash[:last] = "" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end
    
    describe "when adding a user with address blank" do
      it "should return ADDRESS_NOT_VALID" do
        expected = { errCode: ADDRESS_NOT_VALID }.to_json
        @user_hash[:residence][:address] = "" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end
    
    describe "when adding a user with city blank" do
      it "should return CITY_NOT_VALID" do
        expected = { errCode: CITY_NOT_VALID }.to_json
        @user_hash[:residence][:city] = "" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end
    
    describe "when adding a user with zip blank" do
      it "should return ZIP_NOT_VALID" do
        expected = { errCode: ZIP_NOT_VALID }.to_json
        @user_hash[:residence][:zip] = "" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end
    
    describe "when adding a user with contact one blank" do
      it "should return CONTACT_ONE_NOT_VALID" do
        expected = { errCode: CONTACT_ONE_NOT_VALID }.to_json
        @user_hash[:contacts][:first][:name] = "" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end
    
    describe "when adding a user with contact one primary blank" do
      it "should return CONTACT_ONE_PRIMARY_NOT_VALID" do
        expected = { errCode: CONTACT_ONE_PRIMARY_NOT_VALID }.to_json
        @user_hash[:contacts][:first][:primary] = "" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end
    
    describe "when adding a user with contact one secondary blank" do
      it "should return CONTACT_ONE_SECONDARY_NOT_VALID" do
        expected = { errCode: CONTACT_ONE_SECONDARY_NOT_VALID }.to_json
        @user_hash[:contacts][:first][:secondary] = "" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end
    
    describe "when adding a user with contact two blank" do
      it "should return CONTACT_TWO_NOT_VALID" do
        expected = { errCode: CONTACT_TWO_NOT_VALID }.to_json
        @user_hash[:contacts][:second][:name] = "" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end
    
    describe "when adding a user with contact two primary blank" do
      it "should return CONTACT_TWO_PRIMARY_NOT_VALID" do
        expected = { errCode: CONTACT_TWO_PRIMARY_NOT_VALID }.to_json
        @user_hash[:contacts][:second][:primary] = "" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end
    
    describe "when adding a user with contact two secondary blank" do
      it "should return CONTACT_TWO_SECONDARY_NOT_VALID" do
        expected = { errCode: CONTACT_TWO_SECONDARY_NOT_VALID }.to_json
        @user_hash[:contacts][:second][:secondary] = "" 
        post '/Users/update', @user_hash  
        response.body.should == expected
      end
    end

    describe "when adding a user with invalid email" do
      it "should return EMAIL_NOT_VALID" do
        expected = { errCode: EMAIL_NOT_VALID }.to_json
        @user_hash[:email] = "invalid email"
        post '/Users/update', @user_hash
        response.body.should == expected
      end
    end

    describe "when adding a user with a taken email" do
      it "should return USER_EXISTS" do
        expected = { errCode: USER_EXISTS }.to_json
        temp_user = FactoryGirl.create(:member_student, email: "temp@temp.com") 
        @user_hash[:email] = temp_user.email
        post '/Users/update', @user_hash
        response.body.should == expected
      end
    end
    
    describe "when adding a user with gender blank" do
      it "should return GENDER_NOT_VALID" do
        expected = { errCode: GENDER_NOT_VALID }.to_json
        @user_hash[:gender] = "bat"
        post '/Users/update', @user_hash
        response.body.should == expected
      end
    end
    
    describe "when adding a user with skill blank" do
      it "should return SKILL_NOT_VALID" do
        expected = { errCode: SKILL_NOT_VALID }.to_json
        @user_hash[:skill] = "gifted"
        post '/Users/update', @user_hash
        response.body.should == expected
      end
    end
    
    describe "when adding a user with extra too long" do
      it "should return EXTRA_NOT_VALID" do
        expected = { errCode: EXTRA_NOT_VALID }.to_json
        @user_hash[:extra] = "a" * 257
        post '/Users/update', @user_hash
        response.body.should == expected
      end
    end
  end
end
