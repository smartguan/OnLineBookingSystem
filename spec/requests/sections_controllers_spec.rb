require 'spec_helper'

describe "SectionsControllers" do

  #--------------------------------
  #Error message => errCode
  SUCCESS = 1
  
  #Error codes can only be used by Admin
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
  
  describe SectionsController do
    #test for createSection
    describe "#createSection" do
      
      context "when all valid" do
        it "should render json {name:name, errCode: 1}" do
          expected = {name:sec_json[:name], errCode: SUCCESS}.to_json
          sec1_json = sec_json.dup
          post '/Admin/createSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when name not valid" do
        it "should render json {name:name, errCode: 200}" do
          sec1_json = sec_json.dup
          sec1_json[:name] = "" 
          expected = {name:sec1_json[:name], errCode: SEC_NAME_INVALID}.to_json
          post '/Admin/createSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when day not valid" do
        it "should render json {name:name, errCode: 201}" do
          expected = {name:sec_json[:name], errCode: DAY_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:day] = "" 
          post '/Admin/createSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when description not valid" do
        it "should render json {name:name, errCode: 202}" do
          expected = {name:sec_json[:name], errCode: DESCR_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:description] = "" 
          post '/Admin/createSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when teacher not valid" do
        it "should render json {name:name, errCode: 203}" do
          expected = {name:sec_json[:name], errCode: TEACHER_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:teacher] = "   " 
          post '/Admin/createSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when section overlap with the same teacher" do
        it "should render json {name:name, errCode: 204}" do
          sec1_json = sec_json.dup
          sec1_json[:name] = "ANOTHER_SEC"
          expected = {name:sec1_json[:name], errCode: SEC_OVERLAP_FOR_TEACHER}.to_json
          post '/Admin/createSection', sec_json
          post '/Admin/createSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 205}" do
          expected = {name:sec_json[:name], errCode: TIME_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:start_time] = "21:00:00"
          post '/Admin/createSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 206}" do
          expected = {name:sec_json[:name], errCode: DATE_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:start_date] = "2020-12-12"
          post '/Admin/createSection', sec1_json
          response.body.should == expected
        end
      end 
    end

    #test for /Admin/editSection
    describe "#editSection" do
      
      context "when all valid" do
        it "should render json {name:secName, errCode: 1}" do
          sec1_json = {name:"A_SEC", day:"SUNDAY", 
                      description:"This section is good", 
                      start_time:"00:00:00", end_time:"10:00:00", 
                      enroll_cur:0,enroll_max:30, 
                      start_date:"2012-10-10", end_date:"2013-10-10",
                      teacher:"A_TEACHER", 
                      waitlist_cur:0, waitlist_max:30,
                      format: :json}
          expected = {name:sec1_json[:name], errCode: SUCCESS}.to_json
          post '/Admin/createSection', sec_json
          post '/Admin/editSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when day not valid" do
        it "should render json {name:name, errCode: 201}" do
          sec1_json = sec_json.dup
          sec1_json[:day] = " " 
          expected = {name:sec1_json[:name], errCode: DAY_INVALID}.to_json
          post '/Admin/createSection', sec_json
          post '/Admin/editSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when description not valid" do
        it "should render json {name:name, errCode: 202}" do
          expected = {name:sec_json[:name], errCode: DESCR_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:description] = "" 
          post '/Admin/createSection', sec_json
          post '/Admin/editSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when teacher not valid" do
        it "should render json {name:name, errCode: 203}" do
          expected = {name:sec_json[:name], errCode: TEACHER_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:teacher] = "   " 
          post '/Admin/createSection', sec_json
          post '/Admin/editSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when section overlap with the same teacher" do
        it "should render json {name:name, errCode: 204}" do
          sec1_json = sec_json.dup
          sec1_json[:name] = "ANOTHER_SEC"
          sec1_json[:day] = "FRIDAY"
          sec2_json = sec1_json.dup
          sec2_json[:day] = sec_json[:day]
          expected = {name:sec1_json[:name], errCode: SEC_OVERLAP_FOR_TEACHER}.to_json
          post '/Admin/createSection', sec_json
          post '/Admin/createSection', sec1_json
          post '/Admin/editSection', sec2_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 205}" do
          expected = {name:sec_json[:name], errCode: TIME_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:start_time] = "21:00:00"
          post '/Admin/createSection', sec_json
          post '/Admin/editSection', sec1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 206}" do
          expected = {name:sec_json[:name], errCode: DATE_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:start_date] = "2020-12-12"
          post '/Admin/createSection', sec_json
          post '/Admin/editSection', sec1_json
          response.body.should == expected
        end
      end 
    end

    
    #test for delete a section
    describe "#deleteSection" do
      context "when delete completed" do
        it "should render json: {name:name, errCode: 1}" do
          expected = {name:sec_json[:name], errCode: SUCCESS}.to_json
          post '/Admin/createSection', sec_json
          post '/Admin/deleteSection', sec_json
          response.body.should == expected
        end
      end

      #test for failure on delete to be continued...
    end
  

    #test for getting all sections
    describe "#getSchedule" do
      #context "when there is at least 1 sections" do
      #  it "should render json: {:sections=>list, errCode: 1}" do
      #    sec1_json = sec_json.dup
      #    sec1_json[:name] = 'SEC_B'
      #    sec1_json[:day] = 'FRIDAY'
      #    expected = {:sections=>[sec_json, sec1_json], errCode: SUCCESS}.to_json
      #    post '/Admin/createSection', sec_json
      #    post '/Admin/createSection', sec1_json
      #    get '/Registrations/getSchedule', {format: :json}
      #    response.body.should == expected
      #  end
      #end

      context "when there is no section" do
        it "should render json: { errCode: 300}" do
          expected = { errCode: 300 }.to_json
          post '/Registrations/getSchedule', {format: :json}
          response.body.should == expected
        end
      end

    end


    #test for view one section
    describe "#viewOneSection" do
      #context "when the section exists" do
      #  it "should render json: {:sections=>section, errCode: 1}" do
      #    sec1_json = sec_json.dup
      #    sec1_json[:name] = 'SEC_B'
      #    sec1_json[:day] = 'FRIDAY'
      #    test_json = {name:sec1_json[:name], format: :json}
      #    expected = {:sections=>[sec1_json], errCode: SUCCESS}.to_json
      #    post '/Admin/createSection', sec_json
      #    post '/Admin/createSection', sec1_json
      #    get '/Registrations/viewOneSection', test_json
      #    response.body.should == expected
      #  end
      #end

      context "when there is no section" do
        it "should render json: { errCode: 300}" do
          test_json = {name:sec_json[:name], format: :json}
          expected = { sections:[], errCode: 300 }.to_json
          get '/Registrations/viewOneSection', test_json
          response.body.should == expected
        end
      end

    end


    #test for user section
    describe "#register" do
      before (:each) do
        test_json = {user_email:user_json[:email], 
                     section_name:sec_json[:name], format: :json}
        post '/Users/add', user_json
        post '/Admin/createSection', sec_json
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
          post '/Registrations/getSchedule', {format: :json}
          JSON.parse(response.body)['sections'][0]['enroll_cur'].should == 1
        end
      end

      context "when user already in the section" do
        it "should render json: { sections:[{section_id:1, section_name:A_SEC, statusCode:2}], errCode: 1}" do
          expected = { sections:[{section_id:1, 
                                  section_name:sec_json[:name], 
                                  statusCode:2}], 
                       errCode: 301 }.to_json
          test_json = {user_email:user_json[:email], 
                       section_name:sec_json[:name], format: :json}
          post '/Registrations/register', test_json
          response.body.should == expected
        end
      end

      context "when section enrollment is full" do
        it "should place use to waitlist and thus render json: { sections:[{section_id:1, section_name:A_SEC, statusCode:3}], errCode: 301}" do
          expected = { sections:[{section_id:1,
                                  section_name:sec_json[:name], 
                                  statusCode:3}], 
                       errCode: 301 }.to_json
          5.times do 
            user_json[:email] = "a" + user_json[:email]
            test_json = {user_email:user_json[:email], 
                         section_name:sec_json[:name], format: :json}
            post '/Users/add', user_json
            post '/Registrations/register', test_json
          end
          response.body.should == expected
        end
      end

      #entry left for testing the waitlist, which might required 
      #a seperate model  WaitList
    end



    #test for user dropping a section
    describe "#drop" do
      before (:each) do
        test_json = {user_email:user_json[:email], 
                     section_name:sec_json[:name], format: :json}
        post '/Users/add', user_json
        post '/Admin/createSection', sec_json
        post '/Registrations/register', test_json
      end
      
      context "when successfully dropped a section with waitlist_cur==0" do
        before (:each) do
          test_json = {user_email:user_json[:email], 
                       section_name:sec_json[:name], format: :json}
          post '/Registrations/drop', test_json

        end
        
        it "should render json: { section_name:A_SEC, errCode: 1}" do
          expected = { section_id:1, section_name: 'A_SEC', errCode: 1 }.to_json
          response.body.should == expected
        end

        it "should decrement enroll_cur" do
          expected = 0
          post "/Registrations/getSchedule", {format: :json}
          JSON.parse(response.body)['sections'][0]['enroll_cur'].should == 0
        end
      end
      
      #tests for waitlist != 0 and @user & @sec actually get disconnected
      #left for later
    end


    #test for a user to view his/her enrolled sections
    describe "#viewEnrolledSections" do
      #context "when user has enrolled at least 1 sections" do
      #  it "should render json: { sections:[{}, {}], errCode: 1}" do
      #    test_json = {user_email:user_json[:email], 
      #                 section_name:sec_json[:name], format: :json}
      #    post '/Users/add', user_json
      #    post '/Admin/createSection', sec_json
      #    post '/Registrations/register', test_json
      #    input_json = {user_email:user_json[:email], format: :json}
      #    expected = { sections:[sec_json] ,errCode: 1 }.to_json
      #    get '/Registrations/viewEnrolledSections', input_json
      #    response.body.should == expected
      #  end
      #end

      context "when user has no section" do
        it "should render json: { sections:[], errCode: 303}" do
          post '/Users/add', user_json
          input_json = {user_email:user_json[:email], format: :json}
          expected = { sections:[] ,errCode: 303 }.to_json
          get '/Registrations/viewEnrolledSections', input_json
          response.body.should == expected
        end
      end

    end



  end
end
