require 'spec_helper'

describe "SectionsControllers" do
=begin
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
  NO_SECTION_FOUND = 250
  FAILED_TO_MAKE_REG = 301
    #statusCodes
    USER_ALREADY_IN_SEC = 2
    ADD_TO_WAIT_LIST = 3
    WAIT_LIST_FULL = 4
    PASS_ADD_DEADLINE = 5
  USER_NOT_REG = 303

  #--------------------------------
=end 
  days_in_week= ['sunday', 'monday', 'tuesday', 'wednesday',
                 'thursday', 'friday', 'saturday']
  
  sec_json = {name:"SEC_A", #day:"MONDAY", 
              description:"This section won't teach you swimming", 
              start_time:"10:00:00", end_time:"20:00:00", 
              enroll_cur:0,enroll_max:5, 
              start_date:"2013-04-15", end_date:"2013-04-15",
              teacher:"SUCKER last", 
              waitlist_cur:0, waitlist_max:5,
              section_type:"C", lesson_type:"PRIVATE",
              format: :json}
  
  user_json = { first: "SUCKER", last: "last", dob: "00/11/2222", 
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
                          format: :json } 

  before do
    FactoryGirl.create(:admin)
    post '/Users/login', { email: "admin@admin.org", password: "password",
                           format: :json }
    user_json1 = user_json.dup
    user_json1[:first] = 'SUCKER'
    user_json1[:email] = 'SUCKER@t.com'
    post 'Admin/addInstructor', user_json1
    user_json1[:first] = 'SUCKER1'
    user_json1[:email] = 'SUCKER1@t.com'
    post 'Admin/addInstructor', user_json1
    user_json1[:first] = 'SUCKER2'
    user_json1[:email] = 'SUCKER2@t.com'
    post 'Admin/addInstructor', user_json1
    user_json1[:first] = 'SUCKER3'
    user_json1[:email] = 'SUCKER3@t.com'
    post 'Admin/addInstructor', user_json1
    user_json1[:first] = 'SUCKER4'
    user_json1[:email] = 'SUCKER4@t.com'
    post 'Admin/addInstructor', user_json1
    # post '/Users/logout', { format: :json }
  end


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
    
      #context "when name not valid" do
      #  it "should render json {name:name, errCode: 200}" do
      #    sec1_json = sec_json.dup
      #    sec1_json[:name] = "" 
      #    expected = {name:sec1_json[:name], errCode: SEC_NAME_INVALID}.to_json
      #    post '/Sections/create', sec1_json
      #    response.body.should == expected
      #  end
      #end
    
      #context "when day not valid" do
      #  it "should render json {name:name, errCode: 201}" do
      #    expected = {name:sec_json[:name], errCode: DAY_INVALID}.to_json
      #    sec1_json = sec_json.dup
      #    sec1_json[:day] = "" 
      #    post '/Sections/create', sec1_json
      #    response.body.should == expected
      #  end
      #end
    
      #context "when description not valid" do
      #  it "should render json {name:name, errCode: 202}" do
      #    expected = {name:sec_json[:name], errCode: DESCR_INVALID}.to_json
      #    sec1_json = sec_json.dup
      #    sec1_json[:description] = "" 
      #    post '/Sections/create', sec1_json
      #    response.body.should == expected
      #  end
      #end
    
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
          sec1_json = {id:1, name:"SEC_A", #day:"SUNDAY", 
                      description:"This section is good", 
                      start_time:"00:00:00", end_time:"10:00:00", 
                      enroll_cur:0,enroll_max:30, 
                      start_date:"2013-04-21", end_date:"2013-04-21",
                      teacher:"SUCKER last", 
                      waitlist_cur:0, waitlist_max:30, 
                      section_type:"C", lesson_type:"PRIVATE",
                      format: :json}
          expected = {name:sec1_json[:name], errCode: SUCCESS}.to_json
          post '/Sections/create', sec_json
          post '/Sections/edit', sec1_json
          response.body.should == expected
        end
      end
    
      #context "when day not valid" do
      #  it "should render json {name:name, errCode: 201}" do
      #    sec1_json = sec_json.dup
      #    sec1_json[:id] = 1
      #    sec1_json[:day] = " " 
      #    expected = {name:sec1_json[:name], errCode: DAY_INVALID}.to_json
      #    post '/Sections/create', sec_json
      #    post '/Sections/edit', sec1_json
      #    response.body.should == expected
      #  end
      #end
    
      #context "when description not valid" do
      #  it "should render json {name:name, errCode: 202}" do
      #    expected = {name:sec_json[:name], errCode: DESCR_INVALID}.to_json
      #    sec1_json = sec_json.dup
      #    sec1_json[:description] = "" 
      #    sec1_json[:id] = 1
      #    post '/Sections/create', sec_json
      #    post '/Sections/edit', sec1_json
      #    response.body.should == expected
      #  end
      #end
    
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
          sec1_json[:start_date] = "2013-04-23"
          sec1_json[:end_date] = "2013-04-23"
          sec1_json[:id] = 2
          sec2_json = sec1_json.dup
          sec2_json[:start_date] = "2013-04-15"
          sec2_json[:end_date] = "2013-04-25"
          sec2_json[:section_type] = "A"
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
        it "should render json: { errCode: 250}" do
          expected = { errCode: 250 }.to_json
          post '/Sections/getAllSections', {format: :json}
          response.body.should == expected
        end
      end

    end


    #test for view one section
    describe "#getSectionByID" do
      before(:each) do
        sec1_json = sec_json.dup
        sec1_json[:name] = 'SEC_B'
        sec1_json[:start_date] = "2013-04-20"
        sec1_json[:end_date] = "2013-04-28"
        sec1_json[:section_type] = "B"
        post '/Sections/create', sec_json
        post '/Sections/create', sec1_json

      end
      
      
      context "when the section exists" do
      #  it "should render json: {:sections=>section, errCode: 1}" do
      #    test_json = {id:2, format: :json}
      #    expected = {:sections=>[sec1_json.sort], errCode: SUCCESS}.to_json
      #    post '/Sections/getSectionByID', test_json
      #    response.body.should == expected
      #  end
      #end
        it "should return section with name SEC_A" do
          test_json = {id:1, format: :json}
          expected = 'SEC_A'
          post '/Sections/getSectionByID', test_json
          JSON.parse(response.body)['sections'][0]['name'].should == expected
        end
      
        it "should return section with name SEC_B" do
          test_json = {id:2, format: :json}
          expected = 'SEC_B'
          post '/Sections/getSectionByID', test_json
          JSON.parse(response.body)['sections'][0]['name'].should == expected
        end
      end


      context "when there is no section" do
        it "should render json: { errCode: 250}" do
          test_json = {id:3, format: :json}
          expected = { sections:[], errCode: 250 }.to_json
          post '/Sections/getSectionByID', test_json
          response.body.should == expected
        end
      end

    end

    #test for get sections by instructor
    describe "#getSectionsByInstructor" do
      before(:each) do
        sec1_json = sec_json.dup
        sec1_json[:name] = 'SEC_C'
        sec1_json[:start_date] = "2013-04-26"
        sec1_json[:end_date] = "2013-04-26"
        post '/Sections/create', sec_json
        post '/Sections/create', sec1_json

      end
      
      
      context "when the section exists" do
      #  it "should render json: {:sections=>section, errCode: 1}" do
      #    test_json = {first:sec_json[:teacher], format: :json}
      #    expected = {:sections=>[sec1_json.sort], errCode: SUCCESS}.to_json
      #    post '/Sections/getSectionsByInstructor', test_json
      #    response.body.should == expected
      #  end
      #end
        it "should return 2 sections" do
          test_json = {teacher:sec_json[:teacher], format: :json}
          expected = 2
          post '/Sections/getSectionsByInstructor', test_json
          JSON.parse(response.body)['sections'].size.should == expected
        end
      
        it "should return errCode 1" do
          test_json = {teacher:sec_json[:teacher], format: :json}
          expected = 1
          post '/Sections/getSectionsByInstructor', test_json
          JSON.parse(response.body)['errCode'].should == expected
        end
      end


      context "when there is no section" do
        it "should render json: { errCode: 250}" do
          test_json = {teacher:'SUCKER1 last', format: :json}
          expected = { sections:[], errCode: 250 }.to_json
          post '/Sections/getSectionsByInstructor', test_json
          response.body.should == expected
        end
      end

    end


    #test for view one section
    describe "#getAvailableSectionsFromNowOn" do
      before(:each) do
          # calculate day in the future
          start_monday = Time.now + (7 - Time.now.wday + 1).days
          start_saturday = Time.now + (7 - Time.now.wday + 6).days
          #sec1
          sec1_json = sec_json.dup
          sec1_json[:name] = 'SEC_1'
          sec1_json[:start_date] = start_monday.to_date
          sec1_json[:end_date] = (start_monday + 10.days).to_date
          sec1_json[:teacher] = 'SUCKER1 last'
          sec1_json[:section_type] = 'A'
          # sec2
          sec2_json = sec_json.dup
          sec2_json[:name] = 'SEC_2'
          sec2_json[:start_date] = start_saturday.to_date
          sec2_json[:end_date] = (start_saturday + 8.days).to_date
          sec2_json[:teacher] = 'SUCKER2 last'
          sec2_json[:section_type] = 'B'
          # sec3
          sec3_json = sec_json.dup
          sec3_json[:name] = 'SEC_3'
          sec3_json[:start_date] = Time.now.to_date
          sec3_json[:end_date] = Time.now.to_date
          sec3_json[:start_time] = '22:00:00'
          sec3_json[:end_time] = '23:00:00'
          sec3_json[:teacher] = 'SUCKER3 last'
          sec3_json[:section_type] = 'C'

          post '/Sections/create', sec_json
          post '/Sections/create', sec1_json
          post '/Sections/create', sec2_json
          post '/Sections/create', sec3_json
      end
      
      
      context "when the section exists" do
        before(:each) do
          test_json = {format: :json}
          post '/Sections/getAvailableSectionsFromNowOn', test_json
        end
        
        #it "should render json: {:sections=>section_list, errCode: 1}" do
          #test_json = {date:"2013-04-15", time:"10:00:00", format: :json}
          #expected = {:sections=>[sec1_json, sec2_json, sec3_json], errCode: SUCCESS}.to_json
          #expected = {}.to_json
          #post '/Sections/getAvailableSectionsByDateAndTime', test_json
          #post '/Sections/getAllSections', {format: :json}
          #response.body.should == expected
        #end
        
        
        it "should return 3 sections" do
          expected = 3
          JSON.parse(response.body)['sections'].size.should == expected
          #post '/Sections/getAllSections', {format: :json}
          #response.body.should == 1
        end
      end

      context "when there is a section before current date" do
        it "should render json: { errCode: 250}" do
          # sec4
          sec4_json = sec_json.dup
          sec4_json[:name] = 'SEC_4'
          sec4_json[:start_date] = '2012-04-18'
          sec4_json[:end_date] = '2012-04-18'
          sec4_json[:teacher] = 'SUCKER4 last'
          sec4_json[:section_type] = 'C'
          post '/Sections/create', sec4_json
          
          test_json = {format: :json}
          expected = 3
          post '/Sections/getAvailableSectionsFromNowOn', test_json
          JSON.parse(response.body)['sections'].size.should == expected
        end
      end

      context "when there is a section in a same date but a time before" do
        it "should render json: { errCode: 250}" do
          # sec4
          sec4_json = sec_json.dup
          sec4_json[:name] = 'SEC_4'
          sec4_json[:start_date] = Time.now.to_date
          sec4_json[:end_date] = Time.now.to_date
          sec4_json[:start_time] = '00:00:00'
          sec4_json[:end_time] = '01:00:00'
          sec4_json[:teacher] = 'SUCKER4 last'
          sec4_json[:section_type] = 'C'
          post '/Sections/create', sec4_json
          
          test_json = {format: :json}
          expected = 3
          post '/Sections/getAvailableSectionsFromNowOn', test_json
          JSON.parse(response.body)['sections'].size.should == expected
        end
      end

    end



    #test for view one section
    describe "#getAvailableSectionsByDateAndTime" do
      before(:each) do
          # calculate day in the future
          start_monday = Time.now + (7 - Time.now.wday + 1).days
          start_saturday = Time.now + (7 - Time.now.wday + 6).days
          #sec1
          sec1_json = sec_json.dup
          sec1_json[:name] = 'SEC_1'
          sec1_json[:start_date] = start_monday.to_date
          sec1_json[:end_date] = (start_monday + 10.days).to_date
          sec1_json[:teacher] = 'SUCKER1 last'
          sec1_json[:section_type] = 'A'
          # sec2
          sec2_json = sec_json.dup
          sec2_json[:name] = 'SEC_2'
          sec2_json[:start_date] = start_saturday.to_date
          sec2_json[:end_date] = (start_saturday + 8.days).to_date
          sec2_json[:teacher] = 'SUCKER2 last'
          sec2_json[:section_type] = 'B'
          # sec3
          sec3_json = sec_json.dup
          sec3_json[:name] = 'SEC_3'
          sec3_json[:start_date] = Time.now.to_date
          sec3_json[:end_date] = Time.now.to_date
          sec3_json[:start_time] = '22:00:00'
          sec3_json[:end_time] = '23:00:00'
          sec3_json[:teacher] = 'SUCKER3 last'
          sec3_json[:section_type] = 'C'

          post '/Sections/create', sec_json
          post '/Sections/create', sec1_json
          post '/Sections/create', sec2_json
          post '/Sections/create', sec3_json
      end
      
      
      context "when the section exists" do
        before(:each) do
          test_json = {date:Time.now.to_date, time:"10:00:00", format: :json}
          post '/Sections/getAvailableSectionsByDateAndTime', test_json
        end
        
        #it "should render json: {:sections=>section_list, errCode: 1}" do
        #  test_json = {date:"2013-04-15", time:"10:00:00", format: :json}
        #  #expected = {:sections=>[sec1_json, sec2_json, sec3_json], errCode: SUCCESS}.to_json
        #  expected = {}.to_json
        #  post '/Sections/getAvailableSectionsByDateAndTime', test_json
        #  response.body.should == expected
        #end
        
        
        it "should return 3 sections" do
          expected = 3
          JSON.parse(response.body)['sections'].size.should == expected
        end
      end

      context "when there is no section" do
        it "should render json: { errCode: 250}" do
          test_json = {date:30.days.from_now, time:"10:00:00", format: :json}
          expected = { sections:[], errCode: 250 }.to_json
          post '/Sections/getAvailableSectionsByDateAndTime', test_json
          response.body.should == expected
        end
      end

    end




  end
end
