require 'spec_helper'

describe "RegistrationsControllers" do

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

  #--------------------------------
  
  reg_json = {name:"A_SEC", day:"MONDAY", 
              description:"This section won't teach you swimming", 
              start_time:"10:00:00", end_time:"20:00:00", 
              enroll_cur:0,enroll_max:40, 
              start_date:"2011-10-10", end_date:"2012-10-10",
              teacher:"SUCKER", 
              waitlist_cur:0, waitlist_max:40,
              format: :json}
  
  describe RegistrationsController do
    #test for createSection
    describe "#createSection" do
      
      context "when all valid" do
        it "should render json {name:name, errCode: 1}" do
          expected = {name:reg_json[:name], errCode: SUCCESS}.to_json
          reg1_json = reg_json.dup
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when name not valid" do
        it "should render json {name:name, errCode: 200}" do
          reg1_json = reg_json.dup
          reg1_json[:name] = "" 
          expected = {name:reg1_json[:name], errCode: SEC_NAME_INVALID}.to_json
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when day not valid" do
        it "should render json {name:name, errCode: 201}" do
          expected = {name:reg_json[:name], errCode: DAY_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:day] = "" 
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when description not valid" do
        it "should render json {name:name, errCode: 202}" do
          expected = {name:reg_json[:name], errCode: DESCR_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:description] = "" 
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when teacher not valid" do
        it "should render json {name:name, errCode: 203}" do
          expected = {name:reg_json[:name], errCode: TEACHER_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:teacher] = "   " 
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when section overlap with the same teacher" do
        it "should render json {name:name, errCode: 204}" do
          reg1_json = reg_json.dup
          reg1_json[:name] = "ANOTHER_SEC"
          expected = {name:reg1_json[:name], errCode: SEC_OVERLAP_FOR_TEACHER}.to_json
          post '/Admin/createSection', reg_json
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 205}" do
          expected = {name:reg_json[:name], errCode: TIME_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:start_time] = "21:00:00"
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 206}" do
          expected = {name:reg_json[:name], errCode: DATE_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:start_date] = "2020-12-12"
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end 
    end

    #test for /Admin/editSection
    describe "#editSection" do
      
      context "when all valid" do
        it "should render json {name:secName, errCode: 1}" do
          reg1_json = {name:"A_SEC", day:"SUNDAY", 
                      description:"This section is good", 
                      start_time:"00:00:00", end_time:"10:00:00", 
                      enroll_cur:0,enroll_max:30, 
                      start_date:"2012-10-10", end_date:"2013-10-10",
                      teacher:"A_TEACHER", 
                      waitlist_cur:0, waitlist_max:30,
                      format: :json}
          expected = {name:reg1_json[:name], errCode: SUCCESS}.to_json
          post '/Admin/createSection', reg_json
          post '/Admin/editSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when day not valid" do
        it "should render json {name:name, errCode: 201}" do
          reg1_json = reg_json.dup
          reg1_json[:day] = " " 
          expected = {name:reg1_json[:name], errCode: DAY_INVALID}.to_json
          post '/Admin/createSection', reg_json
          post '/Admin/editSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when description not valid" do
        it "should render json {name:name, errCode: 202}" do
          expected = {name:reg_json[:name], errCode: DESCR_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:description] = "" 
          post '/Admin/createSection', reg_json
          post '/Admin/editSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when teacher not valid" do
        it "should render json {name:name, errCode: 203}" do
          expected = {name:reg_json[:name], errCode: TEACHER_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:teacher] = "   " 
          post '/Admin/createSection', reg_json
          post '/Admin/editSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when section overlap with the same teacher" do
        it "should render json {name:name, errCode: 204}" do
          reg1_json = reg_json.dup
          reg1_json[:name] = "ANOTHER_SEC"
          reg1_json[:day] = "FRIDAY"
          reg2_json = reg1_json.dup
          reg2_json[:day] = reg_json[:day]
          expected = {name:reg1_json[:name], errCode: SEC_OVERLAP_FOR_TEACHER}.to_json
          post '/Admin/createSection', reg_json
          post '/Admin/createSection', reg1_json
          post '/Admin/editSection', reg2_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 205}" do
          expected = {name:reg_json[:name], errCode: TIME_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:start_time] = "21:00:00"
          post '/Admin/createSection', reg_json
          post '/Admin/editSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {name:name, errCode: 206}" do
          expected = {name:reg_json[:name], errCode: DATE_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:start_date] = "2020-12-12"
          post '/Admin/createSection', reg_json
          post '/Admin/editSection', reg1_json
          response.body.should == expected
        end
      end 
    end

    
    #test for delete a section
    describe "#deleteSection" do
      context "when delete completed" do
        it "should render json: {name:name, errCode: 1}" do
          expected = {name:reg_json[:name], errCode: SUCCESS}.to_json
          post '/Admin/createSection', reg_json
          post '/Admin/deleteSection', reg_json
          response.body.should == expected
        end
      end

      #test for failure on delete to be continued...
    end
  

    #test for getting all sections
    describe "#getSchedule" do
      #context "when there is at least 1 sections" do
      #  it "should render json: {:sections=>list, errCode: 1}" do
      #    reg1_json = reg_json.dup
      #    reg1_json[:name] = 'SEC_B'
      #    reg1_json[:day] = 'FRIDAY'
      #    expected = {:sections=>[reg_json, reg1_json], errCode: SUCCESS}.to_json
      #    post '/Admin/createSection', reg_json
      #    post '/Admin/createSection', reg1_json
      #    get '/Registrations/getSchedule', reg1_json
      #    response.body.should == expected
      #  end
      #end

      context "when there is no section" do
        it "should render json: { errCode: 300}" do
          expected = { errCode: 300 }.to_json
          get '/Registrations/getSchedule', reg_json
          response.body.should == expected
        end
      end

    end



  end
end
