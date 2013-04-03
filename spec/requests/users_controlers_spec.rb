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
  ZIP_NOT_VALID = 106
  USER_EXISTS = 107
  BAD_CREDENTIALS = 108

  describe UsersController do
    describe "when adding a valid user" do
      it "should create a user" do
        expect {
          post '/Users/add', first: "first", last: "last", email: "abc@123.com", password: "password", password_confirmation: "password", dob: "01/02/1234", zip: "12345", admin: 0, format: :json }.to change(User, :count).by(1)
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
    
#   Login functionality
    describe "when logging in with invalid email" do
      it "should return BAD_CREDENTIALS" do
        expected = { errCode: BAD_CREDENTIALS }.to_json
        post '/Users/login', { email: "new@email.com", password: "dogbreath", 
                             format: :json }
        response.body.should == expected
      end
    end
    
    describe "when logging in with wrong password" do
      it "should return BAD_CREDENTIALS" do
        expected = { errCode: BAD_CREDENTIALS }.to_json
        User.create(first: "first", last: "last", email: "new@user.net",
                      password: "password", password_confirmation: "password",
                      dob: "01/02/1234", zip: "12345", admin: 0)
        post '/Users/login', { email: "new@user.net", password: "passwerd", 
                             format: :json }
        response.body.should == expected
      end
    end
    
    describe "when logging in with correct email and password" do
      it "should return SUCCESS" do
        expected = { errCode: SUCCESS, admin: false }.to_json
        User.create(first: "first", last: "last", email: "new@user.net",
                      password: "password", password_confirmation: "password",
                      dob: "01/02/1234", zip: "12345", admin: 0)
        post '/Users/login', { email: "new@user.net", password: "password", 
                             format: :json }
        response.body.should == expected
      end
    end

#   Delete functionality
#    describe "when deleting account with invalid email" do
#      it "should return BAD_CREDENTIALS" do
#        expected = { errCode: BAD_CREDENTIALS }.to_json
#        post '/Users/delete', { email: "new@email.com", password: "dogbreath", 
#                                format: :json }
#        response.body.should == expected
#      end
#    end
    
    describe "when deleting account with wrong password", js: true do
      it "should return BAD_CREDENTIALS" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-password", with: "passwerd"
        click_button "test-delete"
        page.should have_content "Delete{\"errCode\":108}"
#        expected = { errCode: BAD_CREDENTIALS }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                      password: "password", password_confirmation: "password",
#                      dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/delete', { email: "new@user.net", password: "passwerd", 
#                             format: :json }
#        response.body.should == expected
      end
    end
    
    describe "when deleting account with correct email and password", js: true do
      it "should display delete user" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-password", with: "password"
        click_button "test-delete"
        page.should have_content "Delete{\"errCode\":1}"
      end
#        expected = { errCode: SUCCESS }.to_json
#        user = User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        get '/Users/delete', { email: "new@user.net", password: "password", 
#                                format: :json }
#        response.body.should == expected
    end

#   Update functionality
    describe "when trying to update an invalid user", js: true do
     it "should return BAD_CREDENTIALS" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-update"
        page.should have_content "Update{\"errCode\":108}"
#        expected = { errCode: BAD_CREDENTIALS }.to_json
#        post '/Users/update', { first: "first", last: "last", email: "abc@123.com", 
#                                password: "password", password_confirmation: "password",
#                                dob: "01/02/1234", zip: "12345",
#                                format: :json }
#        response.body.should == expected
      end
    end
    
#    describe "when trying to update a valid user with invalid password" do
#      it "should return BAD_CREDENTIALS" do
#        expected = { errCode: BAD_CREDENTIALS }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "passwerd",
#                                first: "first", last: "last", email: "abc@123.com", 
#                                password: "password", password_confirmation: "password",
#                                dob: "01/02/1234", zip: "12345",
#                                format: :json }
#        response.body.should == expected
#      end
#    end

    describe "when updating a valid user", js: true do
      it "should return SUCCESS" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-first", with: "banana"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-update"
        page.should have_content "Update{\"errCode\":1}"
#        expected = { errCode: SUCCESS }.to_json
#        User.create(first: "fist", last: "lat", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "04/02/1234", zip: "12344", admin: 1)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password", 
#                                first: "first", last: "last", email: "abc@123.com", 
#                                password: "passwerd", password_confirmation: "passwerd",
#                                dob: "01/02/1234", zip: "12345", format: :json }
#        response.body.should == expected
      end
    end

    describe "when updating a user with first blank", js: true do
      it "should return FIRST_NOT_VALID" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-first", with: ""
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-update"
        page.should have_content "Update{\"errCode\":101}"
#        expected = { errCode: FIRST_NOT_VALID }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: "", last: 0, email: 0, 
#                                password: 0, password_confirmation: 0,
#                                dob: 0, zip: 0, format: :json }
#        response.body.should == expected
      end
    end
   
    describe "when updating a user with last blank", js: true do
      it "should return LAST_NOT_VALID" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-first", with: "first"
        fill_in "test-last", with: ""
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-update"
        page.should have_content "Update{\"errCode\":102}"
#        expected = { errCode: LAST_NOT_VALID }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: 0, last: "", email: 0, 
#                                password: 0, password_confirmation: 0,
#                                dob: 0, zip: 0, format: :json }
#        response.body.should == expected
      end
    end
    
    describe "when updating a user with email blank", js: true do
      it "should return EMAIL_NOT_VALID" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: ""
        fill_in "test-password", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-update"
        page.should have_content "Update{\"errCode\":103}"
#        expected = { errCode: EMAIL_NOT_VALID }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: 0, last: 0, email: "", 
#                                password: 0, password_confirmation: 0,
#                                dob: 0, zip: 0, format: :json }
#        response.body.should == expected
      end
    end
    
    describe "when updating a user with invalid email", js: true do
      it "should return EMAIL_NOT_VALID" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "abcdef"
        fill_in "test-password", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-update"
        page.should have_content "Update{\"errCode\":103}"
#        expected = { errCode: EMAIL_NOT_VALID }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: 0, last: 0, email: "12345", 
#                                password: 0, password_confirmation: 0,
#                                dob: 0, zip: 0, format: :json }
#        response.body.should == expected
      end
    end
    
    describe "when updating a user with a taken email", js: true do
      it "should return USER_EXISTS" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        click_button "test-logout"
        page.should have_content "Logout{\"errCode\":1}"
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "newtwo@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-update"
        page.should have_content "Update{\"errCode\":107}"
#        expected = { errCode: USER_EXISTS }.to_json
#        User.create(first: "first", last: "last", email: "old@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: 0, last: 0, email: "old@user.net", 
#                                password: 0, password_confirmation: 0,
#                                dob: 0, zip: 0, format: :json }
#        response.body.should == expected
      end
    end
    
#    describe "when updating a user with blank password", js: true do
#      it "should return PASS_NOT_VALID" do
#        expected = { errCode: PASS_NOT_VALID }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: 0, last: 0, email: 0, 
#                                password: "", password_confirmation: "",
#                                dob: 0, zip: 0, format: :json }
#        response.body.should == expected
#      end
#    end
    
#    describe "when updating a user when password and password_confirmation don't match", js: true do
#      it "should return PASS_NOT_MATCH" do
#        expected = { errCode: PASS_NOT_MATCH }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: 0, last: 0, email: 0, 
#                                password: "hellodolly", 
#                                password_confirmation: "hellomolly",
#                                dob: 0, zip: 0, format: :json }
#        response.body.should == expected
#      end
#    end
    
    describe "when updating a user with dob blank", js: true do
      it "should return DOB_NOT_VALID" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-dob", with: ""
        fill_in "test-zip", with: "12345"
        click_button "test-update"
        page.should have_content "Update{\"errCode\":105}"
#        expected = { errCode: DOB_NOT_VALID }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: 0, last: 0, email: 0, 
#                                password: 0, password_confirmation: 0,
#                                dob: "", zip: 0, format: :json }
#        response.body.should == expected
      end
    end
    
    describe "when updating a user with invalid dob", js: true do
      it "should return DOB_NOT_VALID" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-dob", with: "0000/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-update"
        page.should have_content "Update{\"errCode\":105}"
#        expected = { errCode: DOB_NOT_VALID }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: 0, last: 0, email: 0, 
#                                password: 0, password_confirmation: 0,
#                                dob: "123", zip: 0, format: :json }
#        response.body.should == expected
      end
    end
    
    describe "when updating a user with zip blank", js: true do
      it "should return ZIP_NOT_VALID" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: ""
        click_button "test-update"
        page.should have_content "Update{\"errCode\":106}"
#        expected = { errCode: ZIP_NOT_VALID }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: 0, last: 0, email: 0, 
#                                password: 0, password_confirmation: 0,
#                                dob: 0, zip: "", format: :json }
#        response.body.should == expected
      end
    end
    
    describe "when updating a user with invalid zip", js: true do
      it "should return ZIP_NOT_VALID" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12"
        click_button "test-update"
        page.should have_content "Update{\"errCode\":106}"
#        expected = { errCode: ZIP_NOT_VALID }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        post '/Users/update', { ref_email: "new@user.net", ref_password: "password",
#                                first: 0, last: 0, email: 0, 
#                                password: 0, password_confirmation: 0,
#                                dob: 0, zip: "abc", format: :json }
#        response.body.should == expected
      end
    end

#   Get Users/profile
    describe "when getting a profile", js: true do
      it "should return BAD_CREDENTIALS" do
        visit "/Users/test" 
#        fill_in "test-first", with: "first"
#        fill_in "test-last", with: "last"
#        fill_in "test-email", with: "new@user.net"
#        fill_in "test-password", with: "password"
#        fill_in "test-password_confirmation", with: "password"
#        fill_in "test-dob", with: "00/00/0000"
#        fill_in "test-zip", with: "12345"
#        click_button "test-add"
#        page.should have_content "Add{\"errCode\":1}"
        click_button "test-profile"
        page.should have_content "Profile{\"errCode\":108}"
#        expected = { errCode: BAD_CREDENTIALS }.to_json
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        get '/Users/profile', { email: "neu@user.net", format: :json }
#        response.body.should == expected
      end
    end
    
    describe "when getting a valid profile with no reservations", js: true do
      it "should return SUCCESS" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        click_button "test-profile"
        page.should have_content "Profile{\"errCode\":1,"
#        user = User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        expected = { errCode: SUCCESS, user: user }.to_json
#        get '/Users/profile', { email: "new@user.net", format: :json }
#        response.body.should == expected
      end
    end
    
#    describe "when getting a valid profile with reservations" do
#      it "should return BAD_CREDENTIALS" do
#        expected = { errCode: BAD_CREDENTIALS }
#        User.create(first: "first", last: "last", email: "new@user.net",
#                    password: "password", password_confirmation: "password",
#                    dob: "01/02/1234", zip: "12345", admin: 0)
#        get '/Users/profile', { email: "new@user.net" }
#        response.body.should == expected
#      end
#    end

    describe "when adding a user and then linking to a new page and logging out", js: true do
      it "should return SUCCESS" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        click_link "test-link"
        click_button "test-logout"
        page.should have_content "Logout{\"errCode\":1}"
      end
    end

  describe "when changing a user's password", js: true do
      it "should return SUCCESS" do
        visit "/Users/test" 
        fill_in "test-first", with: "first"
        fill_in "test-last", with: "last"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "password"
        fill_in "test-password_confirmation", with: "password"
        fill_in "test-dob", with: "00/00/0000"
        fill_in "test-zip", with: "12345"
        click_button "test-add"
        page.should have_content "Add{\"errCode\":1}"
        fill_in "test-password", with: "password"
        fill_in "test-new_password", with: "passwerd"
        fill_in "test-new_password_confirmation", with: "passwerd"
        click_button "test-updatePassword"
        page.should have_content "UpdatePassword{\"errCode\":1}"
        fill_in "test-email", with: "new@user.net"
        fill_in "test-password", with: "passwerd"
        click_button "test-login"
        page.should have_content "Login{\"errCode\":1,"
      end
    end

  describe "when changing a non-existant user's password", js: true do
      it "should return BAD_CREDENTIALS" do
        visit "/Users/test" 
        fill_in "test-password", with: "password"
        fill_in "test-new_password", with: "passwerd"
        fill_in "test-new_password_confirmation", with: "passwerd"
        click_button "test-updatePassword"
        page.should have_content "UpdatePassword{\"errCode\":108}"
      end
    end

  end
end
