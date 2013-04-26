require 'spec_helper'

# -------------------------------------------- #
#SUCCESS = 1

NO_INSTRUCTOR_FOUND = 122

# -------------------------------------------- #

  sec_json = {name:"SEC_A", #day:"MONDAY", 
              description:"This section won't teach you swimming", 
              start_time:"10:00:00", end_time:"20:00:00", 
              enroll_cur:0,enroll_max:5, 
              start_date:"2013-04-15", end_date:"2013-04-15",
              teacher:"SUCKER last", 
              waitlist_cur:0, waitlist_max:5,
              section_type:"C", lesson_type:"PRIVATE",
              format: :json}
 




describe "InstructorsControllers" do

  describe "#getAllInstructors" do
    
    context "when there is no instructors" do
      it "should return {instructors:[], errCode:122}" do
        expect = {instructors:[], errCode:122}.to_json
        post '/Instructors/getAllInstructors', {format: :json}
        response.body.should == expect
      end
    end
  
    context "when there is instructors" do
      before(:each) do
        FactoryGirl.create(:instructor)
      end
      
      it "should return errCode:122" do
        expect = 1
        post '/Instructors/getAllInstructors', {format: :json}
        JSON.parse(response.body)['errCode'] == expect
      end
      
      it "should return 1 instructor" do
        expect = 1
        post '/Instructors/getAllInstructors', {format: :json}
        JSON.parse(response.body)['instructors'].size.should == expect
      end
      
      it "should return 2 instructor" do
        FactoryGirl.create(:instructor, email:'a@inst.com')
        expect = 2
        post '/Instructors/getAllInstructors', {format: :json}
        JSON.parse(response.body)['instructors'].size.should == expect
      end
    end
  
  
  end


  describe "#getAvailableInstructors" do

    test_json = { start_date:"2013-04-22", end_date:"2013-05-02",
                  start_time:"10:00:00", end_time:"20:00:00",
                  section_type:"A", format: :json}
    
    before(:each) do
      FactoryGirl.create(:instructor, email:'a@inst.com', first:"T_A")
      FactoryGirl.create(:instructor, email:'b@inst.com', first:"T_B")
      email = "admin_inst@admin.org"
      FactoryGirl.create(:admin, email:email)
      post "/Users/login", {email:email, password:"password", format: :json}
      sec1_json = sec_json.dup
      sec1_json[:name] = "SEC_A"
      sec1_json[:teacher] = "T_A last"
      sec1_json[:end_date] = "2013-04-25"
      sec1_json[:section_type] = "A"
      post '/Sections/create', sec1_json
      
      sec1_json = sec_json.dup
      sec1_json[:name] = "SEC_B"
      sec1_json[:teacher] = "T_B last"
      sec1_json[:start_date] = "2013-04-20"
      sec1_json[:end_date] = "2013-04-28"
      sec1_json[:section_type] = "B"
      post '/Sections/create', sec1_json
    end
    
    context "when there is no instructors available" do
      before do
        sec1_json = sec_json.dup
        sec1_json[:name] = "SEC_C"
        sec1_json[:teacher] = "T_B last"
        sec1_json[:start_date] = "2013-04-22"
        sec1_json[:end_date] = "2013-04-22"
        sec1_json[:section_type] = "C"
        post '/Sections/create', sec1_json
      end
      
      it "should return {instructors:[], errCode:122}" do
        expect = {instructors:[], errCode:122 }.to_json
        #post '/Sections/getAllSections', { format: :json }
        post '/Instructors/getAvailableInstructors', test_json
        response.body.should == expect
      end
    end
  
    context "when one of the instructors is available" do
      it "should return errCode:1" do
        expect = 1
        post '/Instructors/getAvailableInstructors', test_json
        JSON.parse(response.body)['errCode'] == expect
      end
      
      it "should return 1 instructors" do
        expect = 1
        post '/Instructors/getAvailableInstructors', test_json
        JSON.parse(response.body)['instructors'].size.should == expect
      end
      
      it "should return instructor T_B" do
        expect = "T_B"
        post '/Instructors/getAvailableInstructors', test_json
        JSON.parse(response.body)['instructors'][0]['first'].should == expect
      end
      
    end
  
    context "when both instructors are available" do
      before(:each) do
        test1_json = test_json.dup
        test1_json[:start_date] = "2013-05-02"
        test1_json[:section_type] = "C"
        post '/Instructors/getAvailableInstructors', test1_json
      end
      
      it "should return errCode:1" do
        expect = 1
        JSON.parse(response.body)['errCode'] == expect
      end
      
      it "should return 2 instructors" do
        expect = 2
        JSON.parse(response.body)['instructors'].size.should == expect
      end
      
    end
  
  end


end
