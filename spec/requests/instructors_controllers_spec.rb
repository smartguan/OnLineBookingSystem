require 'spec_helper'

# -------------------------------------------- #
SUCCESS = 1

NO_INSTRUCTOR_FOUND = 450

# -------------------------------------------- #

describe "InstructorsControllers" do

  describe "#getAllInstructors" do
    
    context "when there is no instructors" do
      it "should return {instructors:[], errCode:122}" do
        expect = {instructors:[], errCode:122}.to_json
        post '/Instructors/getAllInstructors', {format: :json}
        response.body.should == expect
      end
    end
  
    context "when there is no instructors" do
      before(:each) do
        FactoryGirl.create(:instructor)
      end
      
      it "should return errCode:122" do
        expect = 122
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




end
