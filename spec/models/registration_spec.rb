require 'spec_helper'

describe Registration do
  
  #unit 1: test for correct inputs
  before { @reg = Registration.new(name: "A", day: "MONDAY", 
          description: "this class is aiming to lower down your intellegence", 
          start_date: "2011-11-29", end_date:"2012-12-30", start_time: "10:00:00", 
          end_time: "20:00:00", teacher: "Obamma", enroll_cur:1, enroll_max:2,
          waitlist_cur:30, waitlist_max:40) }
  
  subject { @reg }

  it {should respond_to(:name)}
  it {should respond_to(:day)}
  it {should respond_to(:description)}
  it {should respond_to(:start_date)}
  it {should respond_to(:end_date)}
  it {should respond_to(:start_time)}
  it {should respond_to(:end_time)}
  it {should respond_to(:teacher)}
  it {should respond_to(:enroll_cur)}
  it {should respond_to(:enroll_max)}
  it {should respond_to(:waitlist_cur)}
  it {should respond_to(:waitlist_max)}

  it { should be_valid }

  ##unit 2: test for name presence
  describe "when name is not presence or empty string" do
    before { @reg.name = " " }
    it {should_not be_valid}
  end
  
  #unit 2-1: test for day presence
  describe "when day is not presence or empty string" do
    before { @reg.day = " " }
    it {should_not be_valid}
  end

  #unit 2-2: test for day format
  describe "when day is not presence or empty string" do
    before { @reg.day = "Monday" }
    it {should_not be_valid}
  end

  #unit 3: test for day validation
  describe "when day is wrong" do
    before { @reg.day = "DAD" }
    it {should_not be_valid}
  end

  #unit 4: test for description presence
  describe "when description is not presence or empty string" do
    before { @reg.description = " " }
    it {should_not be_valid}
  end

  #unit 5: test for end_time > start_time
  describe "when end_time is not greater than start_time" do
    before do 
      @reg.start_time = "15:00:00"
      @reg.end_time = "14:00:00"
    end
    it {should_not be_valid}
  end

  #unit 6: test for end_date > start_date
  describe "when end_date is before than start_date" do
    before do 
      @reg.start_date = "2011-11-12"
      @reg.end_date = "2010-11-13"
    end
    it {should_not be_valid}
  end

  #unit 7: test for enroll_cur > enroll_max
  describe "when enroll_cur is great than enroll_max" do
    before do 
      @reg.enroll_cur = 40
      @reg.enroll_max = 30
    end
    it {should_not be_valid}
  end

  #unit 8: test for waitlist_cur > waitlist_max
  describe "when waitlist_cur is great than waitlist_max" do
    before do 
      @reg.waitlist_cur = 40
      @reg.waitlist_max = 30
    end
    it {should_not be_valid}
  end

  #unit 9-1: test for section overlapped_start_time for a teacher
  describe "when sections overlapped_start_time for a teacher" do
    before do 
      @reg.save
      @reg.name = "overlapped_section"
      @reg.start_time = '15:00:00'
      @reg.end_time = '21:00:00'
    end
    it {should_not be_valid}
  end

  #unit 9-2: test for section overlapped_end_time for a teacher
  describe "when sections overlapped_end_time for a teacher" do
    before do 
      @reg.save
      @reg.name = "overlapped_section"
      @reg.start_time = '05:00:00'
      @reg.end_time = '11:00:00'
    end
    it {should_not be_valid}
  end

  #unit 9-3: test for section overlapped_start_end_time for a teacher
  describe "when sections overlapped_start_end_time for a teacher" do
    before do 
      @reg.save
      @reg.name = "overlapped_section"
      @reg.start_time = '05:00:00'
      @reg.end_time = '21:00:00'
    end
    it {should_not be_valid}
  end

  #unit 9-4: test for section overlapped with ovevlapped date for a teacher
  describe "when sections overlapped_date_time for a teacher" do
    before do 
      @reg.save
      @reg.name = "overlapped_section"
      @reg.start_time = '05:00:00'
      @reg.end_time = '21:00:00'
      @reg.start_date =' 2011-05-25'
      @reg.end_date = '2014-05-29'
    end
    it {should_not be_valid}
  end

  #unit 9-5: test for section overlapped with same day for a teacher
  describe "when sections overlapped_date_time_different_day for a teacher" do
    before do 
      @reg.save
      @reg.name = "overlapped_section"
      @reg.day = 'SUNDAY'
      @reg.start_time = '05:00:00'
      @reg.end_time = '21:00:00'
      @reg.start_date =' 2011-05-25'
      @reg.end_date = '2014-05-29'
    end
    it {should be_valid}
  end

  #unit 9-6: test for section overlapped with different teachers
  describe "when sections overlapped for different teachers" do
    before do 
      @reg.save
      @reg.name = "overlapped_section"
      @reg.teacher = 'SUCKER'
      @reg.start_time = '05:00:00'
      @reg.end_time = '21:00:00'
      @reg.start_date =' 2011-05-25'
      @reg.end_date = '2014-05-29'
    end
    it {should be_valid}
  end
end
