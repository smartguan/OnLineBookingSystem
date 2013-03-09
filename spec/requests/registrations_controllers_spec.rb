require 'spec_helper'

describe "RegistrationsControllers" do
  #--------------------------------
  #Error message => errCode
  SEC_NAME_INVALID = 200
  DAY_INVALID = 201
  DESCR_INVALID = 202
  TEACHER_INVALID = 203
  SEC_OVERLAP_FOR_TEACHER = 204
  TIME_INVALID = 205
  DATE_INVALID = 206
  #--------------------------------

  
  reg_json = {name:"SEC_A", day:"Monday", 
              description:"This section doesn't teach you swimming", 
              start_time:"10:00:00", end_time:"20:00:00", 
              enroll_cur:0,enroll_max:40, 
              start_date:"2011-10-10",
              end_date:"2012-10-10",
              teacher:"SUCKER", 
              waitlist_cur:0, waitlist_max:0}
  describe "createSection" do
    it "works! (now write some real specs)" do
    
    end
  end
end
