require 'spec_helper'

describe "RegistrationsControllers" do
  #--------------------------------
  #Error message => errCode
  SUCCESS = 1
  SEC_NAME_INVALID = 200
  DAY_INVALID = 201
  DESCR_INVALID = 202
  TEACHER_INVALID = 203
  SEC_OVERLAP_FOR_TEACHER = 204
  TIME_INVALID = 205
  DATE_INVALID = 206
  #--------------------------------

  
  reg_json = {name:"ok", day:"MONDAY", 
              description:"This section won't teach you swimming", 
              start_time:"10:00:00", end_time:"20:00:00", 
              enroll_cur:0,enroll_max:40, 
              start_date:"2011-10-10", end_date:"2012-10-10",
              teacher:"SUCKER", 
              waitlist_cur:0, waitlist_max:0,
              format: :json}
  
  describe RegistrationsController do
    describe "#createSection" do
      
      context "when all valid" do
        it "should render json {errCode: 1}" do
          expected = {errCode: SUCCESS}.to_json
          reg1_json = reg_json.dup
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when name not valid" do
        it "should render json {errCode: 200}" do
          expected = {errCode: SEC_NAME_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:name] = "" 
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when day not valid" do
        it "should render json {errCode: 201}" do
          expected = {errCode: DAY_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:day] = "" 
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when description not valid" do
        it "should render json {errCode: 202}" do
          expected = {errCode: DESCR_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:description] = "" 
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when teacher not valid" do
        it "should render json {errCode: 203}" do
          expected = {errCode: TEACHER_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:teacher] = "   " 
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when section overlap with the same teacher" do
        it "should render json {errCode: 204}" do
          expected = {errCode: SEC_OVERLAP_FOR_TEACHER}.to_json
          reg1_json = reg_json.dup
          reg1_json[:name] = "adsf"
          post '/Admin/createSection', reg_json
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {errCode: 205}" do
          expected = {errCode: TIME_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:start_time] = "21:00:00"
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end
    
      context "when time not valid" do
        it "should render json {errCode: 206}" do
          expected = {errCode: DATE_INVALID}.to_json
          reg1_json = reg_json.dup
          reg1_json[:start_date] = "2020-12-12"
          post '/Admin/createSection', reg1_json
          response.body.should == expected
        end
      end 
    end


  
  
  
  end
end
