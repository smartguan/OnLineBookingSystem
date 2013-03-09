require 'spec_helper'

describe "UsersControlers" do

  SUCCESS = 1
  FIRST_NOT_VALID = 101
  LAST_NOT_VALID = 102
  EMAIL_NOT_VALID = 103
  PASS_NOT_VALID = 104
  PASS_NOT_MATCH = 109
  DOB_NOT_VALID = 105
  ZIP_NOT_VALID = 106
  USER_EXISTS = 107

  describe UsersController do
    describe "when adding a valid user" do
      it "should create a user" do
      expect {
        post '/Users/add', first: "first", last: "last", email: "abc@123.com", password: "password", password_confirmation: "password", dob: "01/02/1234", zip: "12345", admin: 0, format: :json }.to change(User, :count).by(1)
      end
    end
  end
  
  describe "when adding a valid user" do
    it "should return SUCCESS" do
      expected = { errCode: SUCCESS }.to_json
      post '/Users/add', { first: "first", last: "last", email: "abc@123.com", 
                           password: "password", password_confirmation: "password",
                           dob: "01/02/1234", zip: "12345", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end

  describe "when adding a user with first blank" do
    it "should return FIRST_NOT_VALID" do
      expected = { errCode: FIRST_NOT_VALID }.to_json
      post '/Users/add', { first: "", last: "last", email: "abc@123.com", 
                           password: "password", password_confirmation: "password",
                           dob: "01/02/1234", zip: "12345", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
  
  describe "when adding a user with last blank" do
    it "should return LAST_NOT_VALID" do
      expected = { errCode: LAST_NOT_VALID }.to_json
      post '/Users/add', { first: "first", last: "", email: "abc@123.com", 
                           password: "password", password_confirmation: "password",
                           dob: "01/02/1234", zip: "12345", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
  
  describe "when adding a user with email blank" do
    it "should return EMAIL_NOT_VALID" do
      expected = { errCode: EMAIL_NOT_VALID }.to_json
      post '/Users/add', { first: "first", last: "last", email: "", 
                           password: "password", password_confirmation: "password",
                           dob: "01/02/1234", zip: "12345", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
  
  describe "when adding a user with invalid email" do
    it "should return EMAIL_NOT_VALID" do
      expected = { errCode: EMAIL_NOT_VALID }.to_json
      post '/Users/add', { first: "first", last: "last", email: "blah", 
                           password: "password", password_confirmation: "password",
                           dob: "01/02/1234", zip: "12345", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
  
  describe "when adding a user with a taken email" do
    it "should return USER_EXISTS" do
      expected = { errCode: USER_EXISTS }.to_json
      User.create(first: "first", last: "last", email: "taken@taken.org",
                    password: "password", password_confirmation: "password",
                    dob: "01/02/1234", zip: "12345", admin: 0)
      post '/Users/add', { first: "first", last: "last", email: "taken@taken.org", 
                           password: "password", password_confirmation: "password",
                           dob: "01/02/1234", zip: "12345", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
  
  describe "when adding a user with blank password" do
    it "should return PASS_NOT_VALID" do
      expected = { errCode: PASS_NOT_VALID }.to_json
      post '/Users/add', { first: "first", last: "last", email: "frog@alligator.com", 
                           password: "", password_confirmation: "",
                           dob: "01/02/1234", zip: "12345", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
  
  describe "when adding a user when password and password_confirmation don't match" do
    it "should return PASS_NOT_MATCH" do
      expected = { errCode: PASS_NOT_MATCH }.to_json
      post '/Users/add', { first: "first", last: "last", email: "frog@alligator.com", 
                           password: "password", password_confirmation: "passwerd",
                           dob: "01/02/1234", zip: "12345", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
  
  describe "when adding a user with dob blank" do
    it "should return DOB_NOT_VALID" do
      expected = { errCode: DOB_NOT_VALID }.to_json
      post '/Users/add', { first: "first", last: "last", email: "frog@alligator.com", 
                           password: "password", password_confirmation: "password",
                           dob: "", zip: "12345", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
  
  describe "when adding a user with invalid dob" do
    it "should return DOB_NOT_VALID" do
      expected = { errCode: DOB_NOT_VALID }.to_json
      post '/Users/add', { first: "first", last: "last", email: "frog@alligator.com", 
                           password: "password", password_confirmation: "password",
                           dob: "1-2-1234", zip: "12345", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
  
  describe "when adding a user with zip blank" do
    it "should return ZIP_NOT_VALID" do
      expected = { errCode: ZIP_NOT_VALID }.to_json
      post '/Users/add', { first: "first", last: "last", email: "frog@alligator.com", 
                           password: "password", password_confirmation: "password",
                           dob: "01/02/1234", zip: "", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
  
  describe "when adding a user with invalid zip" do
    it "should return ZIP_NOT_VALID" do
      expected = { errCode: ZIP_NOT_VALID }.to_json
      post '/Users/add', { first: "first", last: "last", email: "frog@alligator.com", 
                           password: "password", password_confirmation: "password",
                           dob: "01/02/1234", zip: "123456", admin: 0,
                           format: :json }
      response.body.should == expected
    end
  end
end
