require 'spec_helper'

describe "RegistrationpControllers" do

  #--------------------------------
  #Error message => errCode
  SUCCESS = 1
  
  #Error codes can only be used by Sections
  SEC_NAME_INVALID = 200
  DAY_INVALID = 201
  DESCR_INVALID = 202
  TEACHER_INVALID = 203
  SEC_OVERLAP_FOR_TEACHER = 204
  TIME_INVALID = 205
  DATE_INVALID = 206
  FAILED_TO_DELETE = 207

  #Error codes can be used by all users
  NO_SECTION_TO_SHOW = 300
  FAILED_TO_MAKE_REG = 301
    #statusCodes
    USER_ALREADY_IN_SEC = 2
    ADD_TO_WAIT_LIST = 3
    WAIT_LIST_FULL = 4
    PASS_ADD_DEADLINE = 5
  USER_NOT_REG = 303

  #--------------------------------
  
  sec_json = {name:"A_SEC", day:"MONDAY", 
              description:"This section won't teach you swimming", 
              start_time:"10:00:00", end_time:"20:00:00", 
              enroll_cur:0,enroll_max:5, 
              start_date:"2011-10-10", end_date:"2012-10-10",
              teacher:"SUCKER", 
              waitlist_cur:0, waitlist_max:5,
              format: :json}
  
  user_json = {first: "first", last: "last", email: "abc@def.com", dob: "01/02/0003", 
               zip: "12345", admin: 0, password: "password", 
               password_confirmation: "password", format: :json}
  
  describe RegistrationsController do
    describe "#register" do
      before (:each) do
        test_json = {section_id:1, format: :json}
        post '/Users/add', user_json
        post '/Sections/create', sec_json
        post '/Registrations/register', test_json
      end
      
      context "when everything the user registers with is valid" do
        it "should render json: { sections:[{section_id:1, section_name:A_SEC, statusCode:1}], errCode: 1}" do
          expected = { sections:[{section_id: 1, 
                                  section_name:sec_json[:name], 
                                  statusCode:1}], 
                       errCode: 1 }.to_json
          response.body.should == expected
        end

        it "should increments enroll_cur by 1" do
          post '/Sections/getAllSections', {format: :json}
          JSON.parse(response.body)['sections'][0]['enroll_cur'].should == 1
        end
      end

      context "when user already in the section" do
        it "should render json: { sections:[{section_id:1, section_name:A_SEC, statusCode:2}], errCode: 1}" do
          expected = { sections:[{section_id:1, 
                                  section_name:sec_json[:name], 
                                  statusCode:2}], 
                       errCode: 301 }.to_json
          test_json = {section_id:1, format: :json}
          post '/Registrations/register', test_json
          response.body.should == expected
        end
      end

      context "when section enrollment is full" do
        before (:each) do
          user_json1 = user_json.dup
          6.times do 
            user_json1[:email] = "a" + user_json1[:email]
            test_json = {section_id:1, format: :json}
            post '/Users/add', user_json1
            post '/Registrations/register', test_json
          end
        end
        
        it "should place user to waitlist and thus render json: { sections:[{section_id:1, section_name:A_SEC, statusCode:3}], errCode: 301}" do
          expected = { sections:[{section_id:1,
                                  section_name:sec_json[:name],
                                  waitlist_place:2,
                                  statusCode:3}], 
                       errCode: 301 }.to_json
          response.body.should == expected
        end

        it "should keep enroll_cur == enroll_max" do
          post '/Sections/getAllSections', {format: :json}
          JSON.parse(response.body)['sections'][0]['enroll_cur'].should == sec_json[:enroll_max]
        end
        
        it "should rank first waitlist_place for aaaaa+email" do
          email = "aaaaa" + user_json[:email]
          #input_json = {user_email:email, format: :json}
          input_json = {format: :json}
          expected = 1
          post '/Users/login', {email:"aaaaaabc@def.com", password:"password", format: :json}
          get '/Registrations/getEnrolledSections', input_json
          JSON.parse(response.body)['sections'][0]['waitlist_place'].should == expected
        end
        
        it "should rank second waitlist_place for aaaaaa+email" do
          email = "aaaaaa" + user_json[:email]
          #input_json = {user_email:email, format: :json}
          input_json = {format: :json}
          expected = 2
          post '/Users/login', {email:"aaaasaabc@def.com", password:"password", format: :json}
          get '/Registrations/getEnrolledSections', input_json
          JSON.parse(response.body)['sections'][0]['waitlist_place'].should == expected
        end
        
      end

      #entry left for testing the waitlist
      context "when waitlist is full" do
        it "should not register user anymore, and render json: { sections:[{section_id:1, section_name:A_SEC, statusCode:4}], errCode: 301}" do
          expected = { sections:[{section_id:1,
                                  section_name:sec_json[:name],
                                  statusCode:4}], 
                       errCode: 301 }.to_json
          user_json1 = user_json.dup
          10.times do 
            user_json1[:email] = "a" + user_json1[:email]
            test_json = {section_id:1, format: :json}
            post '/Users/add', user_json1
            post '/Registrations/register', test_json
          end
          response.body.should == expected
        end
      end


    end



    #test for user dropping a section
    describe "#drop" do
      before (:each) do
        test_json = {section_id:1, format: :json}
        post '/Users/add', user_json
        post '/Sections/create', sec_json
        post '/Registrations/register', test_json
      end
      
      context "when successfully dropped a section with waitlist_cur==0" do
        before (:each) do
          test_json = {section_id:1, format: :json}
          post '/Registrations/drop', test_json

        end
        
        it "should render json: { section_id:1, section_name:A_SEC, errCode: 1}" do
          expected = { section_id:1, section_name: 'A_SEC', errCode: 1 }.to_json
          response.body.should == expected
        end

        it "should decrement enroll_cur" do
          expected = 0
          post "/Sections/getAllSections", {format: :json}
          JSON.parse(response.body)['sections'][0]['enroll_cur'].should == expected
        end
        
        it "should delete section from the user" do
          input_json = {format: :json}
          expected = []
          get '/Registrations/getEnrolledSections', input_json
          JSON.parse(response.body)['sections'].should == expected
        end
        
      end
      
      #tests for waitlist != 0 and @user & @sec actually get disconnected
      context "when dropping a section with waitlist != 0" do
        before (:each) do
          user_json1 = user_json.dup
          6.times do 
            user_json1[:email] = "a" + user_json1[:email]
            test_json = {section_id: 1, format: :json}
            post '/Users/add', user_json1
            post '/Registrations/register', test_json
          end
          test_json = {section_id:1, format: :json}
          post '/Users/login', {email:"abc@def.com", password:"password", format: :json}
          post '/Registrations/drop', test_json 
        end

        it "should render json: { section_id:1, section_name:A_SEC, errCode: 1}" do
          expected = { section_id:1, section_name: 'A_SEC', errCode: 1 }.to_json
          response.body.should == expected
        end

        it "should decrement the waitlist by 1" do
          expected = 1
          post "/Sections/getAllSections", {format: :json}
          JSON.parse(response.body)['sections'][0]['waitlist_cur'].should == expected
        end
        
        it "shoul remain the same for enroll_cur" do
          expected = 5
          post "/Sections/getAllSections", {format: :json}
          JSON.parse(response.body)['sections'][0]['enroll_cur'].should == expected
        end

        it "should pull the first user in the wailist into enroll_cur" do
          email = "aaaaa" + user_json[:email]
          #input_json = {user_email:email, format: :json}
          input_json = {format: :json}
          expected = 0
          post '/Users/login', {email:"aaaaaabc@def.com", password:"password", format: :json}
          get '/Registrations/getEnrolledSections', input_json
          JSON.parse(response.body)['sections'][0]['waitlist_place'].should == expected
        end
        
        it "should rank second in the waitlist_place for aaaaaa+email" do
          email = "aaaaaa" + user_json[:email]
          #input_json = {user_email:email, format: :json}
          input_json = {format: :json}
          expected = 1
          post '/Users/login', {email:"aaaaaaabc@def.com", password:"password", format: :json}
          get '/Registrations/getEnrolledSections', input_json
          JSON.parse(response.body)['sections'][0]['waitlist_place'].should == expected
        end
        
      end
    end


    #test for a user to view his/her enrolled sections
    describe "#getEnrolledSections" do
      #context "when user has enrolled at least 1 sections" do
      #  it "should render json: { sections:[{}, {}], errCode: 1}" do
      #    test_json = {section_id:1, format: :json}
      #    post '/Users/add', user_json
      #    post '/Sections/create', sec_json
      #    post '/Registrations/register', test_json

      #    7.times do 
      #      user_json[:email] = "a" + user_json[:email]
      #      test_json = {section_id:1, format: :json}
      #      post '/Users/add', user_json
      #      post '/Registrations/register', test_json
      #    end


      #    input_json = {format: :json}
      #    expected = { sections:[sec_json, waitlist_place:3] ,errCode: 1 }.to_json
      #    get '/Registrations/getEnrolledSections', input_json
      #    response.body.should == expected
      #  end
      #end

      context "when user has no section" do
        it "should render json: { sections:[], errCode: 303}" do
          post '/Users/add', user_json
          #input_json = {user_email:user_json[:email], format: :json}
          input_json = { format: :json }
          expected = { sections:[] ,errCode: 303 }.to_json
          post '/Users/login', {email:"abc@def.com", password:"password", format: :json}
          get '/Registrations/getEnrolledSections', input_json
          response.body.should == expected
        end
      end

    end



  end
end
