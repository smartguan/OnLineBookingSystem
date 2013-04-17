require 'spec_helper'

describe "SectionsControllers" do

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
  
  describe SectionsController do
    #test for create
    describe "#create" do
      
      context "when all valid" do
        it "should render json {name:name, errCode: 1}" do
          expected = {name:sec_json[:name], errCode: SUCCESS}.to_json
          sec1_json = sec_json.dup
          post '/Sections/create', sec1_json
          response.body.should == expected
        end
      end
    
      context "when name not valid" do
        it "should render json {name:name, errCode: 200}" do
          sec1_json = sec_json.dup
          sec1_json[:name] = "" 
          expected = {name:sec1_json[:name], errCode: SEC_NAME_INVALID}.to_json
          post '/Sections/create', sec1_json
          response.body.should == expected
        end
      end
    
      context "when day not valid" do
        it "should render json {name:name, errCode: 201}" do
          expected = {name:sec_json[:name], errCode: DAY_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:day] = "" 
          post '/Sections/create', sec1_json
          response.body.should == expected
        end
      end
    
      context "when description not valid" do
        it "should render json {name:name, errCode: 202}" do
          expected = {name:sec_json[:name], errCode: DESCR_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:description] = "" 
          post '/Sections/create', sec1_json
          response.body.should == expected
        end
      end
    
      context "when teacher not valid" do
        it "should render json {name:name, errCode: 203}" do
          expected = {name:sec_json[:name], errCode: TEACHER_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:teacher] = "   " 
          post '/Sections/create', sec1_json
          response.body.should == expected
        end
      end
    
      context "when section overlap with the same teacher" do
        it "should render json {name:name, errCode: 204}" do
          sec1_json = sec_json.dup
          sec1_json[:name] = "ANOTHER_SEC"
          expected = {name:sec1_json[:name], errCode: SEC_OVERLAP_FOR_TEACHER}.to_json
          post '/Sections/create', sec_json
          post '/Sections/create', sec1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 205}" do
          expected = {name:sec_json[:name], errCode: TIME_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:start_time] = "21:00:00"
          post '/Sections/create', sec1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 206}" do
          expected = {name:sec_json[:name], errCode: DATE_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:start_date] = "2020-12-12"
          post '/Sections/create', sec1_json
          response.body.should == expected
        end
      end 
    end

    #test for /Sections/edit
    describe "#edit" do
      
      context "when all valid" do
        it "should render json {name:secName, errCode: 1}" do
          sec1_json = {id:1, name:"A_SEC", day:"SUNDAY", 
                      description:"This section is good", 
                      start_time:"00:00:00", end_time:"10:00:00", 
                      enroll_cur:0,enroll_max:30, 
                      start_date:"2012-10-10", end_date:"2013-10-10",
                      teacher:"A_TEACHER", 
                      waitlist_cur:0, waitlist_max:30,
                      format: :json}
          expected = {name:sec1_json[:name], errCode: SUCCESS}.to_json
          post '/Sections/create', sec_json
          post '/Sections/edit', sec1_json
          response.body.should == expected
        end
      end
    
      context "when day not valid" do
        it "should render json {name:name, errCode: 201}" do
          sec1_json = sec_json.dup
          sec1_json[:id] = 1
          sec1_json[:day] = " " 
          expected = {name:sec1_json[:name], errCode: DAY_INVALID}.to_json
          post '/Sections/create', sec_json
          post '/Sections/edit', sec1_json
          response.body.should == expected
        end
      end
    
      context "when description not valid" do
        it "should render json {name:name, errCode: 202}" do
          expected = {name:sec_json[:name], errCode: DESCR_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:description] = "" 
          sec1_json[:id] = 1
          post '/Sections/create', sec_json
          post '/Sections/edit', sec1_json
          response.body.should == expected
        end
      end
    
      context "when teacher not valid" do
        it "should render json {name:name, errCode: 203}" do
          expected = {name:sec_json[:name], errCode: TEACHER_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:teacher] = "   " 
          sec1_json[:id] = 1
          post '/Sections/create', sec_json
          post '/Sections/edit', sec1_json
          response.body.should == expected
        end
      end
    
      context "when section overlap with the same teacher" do
        it "should render json {name:name, errCode: 204}" do
          sec1_json = sec_json.dup
          sec1_json[:name] = "ANOTHER_SEC"
          sec1_json[:day] = "FRIDAY"
          sec1_json[:id] = 1
          sec2_json = sec1_json.dup
          sec2_json[:day] = sec_json[:day]
          sec2_json[:id] = 2
          expected = {name:sec1_json[:name], errCode: SEC_OVERLAP_FOR_TEACHER}.to_json
          post '/Sections/create', sec_json
          post '/Sections/create', sec1_json
          post '/Sections/edit', sec2_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 205}" do
          expected = {name:sec_json[:name], errCode: TIME_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:start_time] = "21:00:00"
          sec1_json[:id] = 1
          post '/Sections/create', sec_json
          post '/Sections/edit', sec1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 206}" do
          expected = {name:sec_json[:name], errCode: DATE_INVALID}.to_json
          sec1_json = sec_json.dup
          sec1_json[:start_date] = "2020-12-12"
          sec1_json[:id] = 1
          post '/Sections/create', sec_json
          post '/Sections/edit', sec1_json
          response.body.should == expected
        end
      end 
    end

    
    #test for delete a section
    describe "#delete" do
      context "when delete completed" do
        it "should render json: {name:name, errCode: 1}" do
          expected = {name:sec_json[:name], errCode: SUCCESS}.to_json
          sec1_json = {id:1, format: :json}
          post '/Sections/create', sec_json
          post '/Sections/delete', sec1_json
          response.body.should == expected
        end
      end

      #test for failure on delete to be continued...
    end
  

    #test for getting all sections
    describe "#getAllSections" do
      #context "when there is at least 1 sections" do
      #  it "should render json: {:sections=>list, errCode: 1}" do
      #    sec1_json = sec_json.dup
      #    sec1_json[:name] = 'SEC_B'
      #    sec1_json[:day] = 'FRIDAY'
      #    expected = {:sections=>[sec_json.sort, sec1_json.sort], errCode: SUCCESS}.to_json
      #    post '/Sections/create', sec_json
      #    post '/Sections/create', sec1_json
      #    post '/Sections/getAllSections', {format: :json}
      #    response.body.should == expected
      #  end
      #end

      context "when there is no section" do
        it "should render json: { errCode: 300}" do
          expected = { errCode: 300 }.to_json
          post '/Sections/getAllSections', {format: :json}
          response.body.should == expected
        end
      end

    end


    #test for view one section
    describe "#getSectionByID" do
      #context "when the section exists" do
      #  it "should render json: {:sections=>section, errCode: 1}" do
      #    sec1_json = sec_json.dup
      #    sec1_json[:name] = 'SEC_B'
      #    sec1_json[:day] = 'FRIDAY'
      #    test_json = {id:2, format: :json}
      #    expected = {:sections=>[sec1_json.sort], errCode: SUCCESS}.to_json
      #    post '/Sections/create', sec_json
      #    post '/Sections/create', sec1_json
      #    post '/Sections/getSectionByID', test_json
      #    response.body.should == expected
      #  end
      #end

      context "when there is no section" do
        it "should render json: { errCode: 300}" do
          test_json = {id:1, format: :json}
          expected = { sections:[], errCode: 300 }.to_json
          post '/Sections/getSectionByID', test_json
          response.body.should == expected
        end
      end

    end


  end
end
