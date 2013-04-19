require 'spec_helper'

describe Section do
  
  #unit 1: test for correct inputs
  before { @sec = Section.new(name: "A_SEC", day: "MONDAY", 
          description: "this class is aiming to lower down your intellegence", 
          start_date: "2011-11-14", end_date:"2011-11-24", start_time: "10:00:00", 
          end_time: "20:00:00", teacher: "Obamma last", enroll_cur:1, enroll_max:2,
          waitlist_cur:30, waitlist_max:40, section_type: "A", lesson_type:"PRIVATE") }
  
  subject { @sec }

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
  it {should respond_to(:section_type)}
  it {should respond_to(:lesson_type)}

  it { should be_valid }

  ###unit 1-1: test for name presence
  #describe "when name is not presence or empty string" do
  #  before { @sec.name = " " }
  #  it {should_not be_valid}
  #end
  #
  ###unit 1-1: test for name duplicate
  #describe "when name is duplicated" do
  #  before do
  #    sec1 = @sec.dup
  #    sec1.save
  #    @sec.day = 'Tuesday'
  #  end
  #  it {should_not be_valid}
  #end
  
  #unit 2-1: test for day presence
  describe "when day is not presence or empty string" do
    before { @sec.day = " " }
    it {should_not be_valid}
  end

  #unit 2-2: test for day format
  describe "when day is lower case" do
    before { @sec.day = "Monday" }
    it {should be_valid}
  end

  #unit 3: test for day validation
  describe "when day is wrong" do
    before { @sec.day = "DAD" }
    it {should_not be_valid}
  end

  ##unit 4: test for description presence
  #describe "when description is not presence or empty string" do
  #  before { @sec.description = " " }
  #  it {should_not be_valid}
  #end

  # unit 4: test for invalid teacher name
  describe "when teacher name is empty" do
    before do
      @sec.teacher = " "
    end
    it { should_not be_valid }
  end
  
  ## unit 4: test for invalid teacher name
  #describe "when teacher missing first or last name" do
  #  before do
  #    @sec.teacher = "SUCK"
  #  end
  #  it { should_not be_valid }
  #end
  
  #unit 5: test for end_time > start_time
  describe "when end_time is not greater than start_time" do
    before do 
      @sec.start_time = "15:00:00"
      @sec.end_time = "14:00:00"
    end
    it {should_not be_valid}
  end

  #unit 6: test for end_date > start_date
  describe "when end_date is before than start_date" do
    before do 
      @sec.start_date = "2011-11-12"
      @sec.end_date = "2010-11-13"
    end
    it {should_not be_valid}
  end

  #unit 7: test for enroll_cur > enroll_max
  describe "when enroll_cur is great than enroll_max" do
    before do 
      @sec.enroll_cur = 40
      @sec.enroll_max = 30
    end
    it {should_not be_valid}
  end

  #unit 8: test for waitlist_cur > waitlist_max
  describe "when waitlist_cur is great than waitlist_max" do
    before do 
      @sec.waitlist_cur = 40
      @sec.waitlist_max = 30
    end
    it {should_not be_valid}
  end

  #unit 9-1: test for section overlapped_start_time for a teacher
  describe "when sections overlapped_start_time for a teacher" do
    before do 
      sec1 = @sec.dup
      sec1.save
      @sec.name = "overlapped_section"
      @sec.start_time = '15:00:00'
      @sec.end_time = '21:00:00'
    end
    it {should_not be_valid}
  end

  #unit 9-2: test for section overlapped_end_time for a teacher
  describe "when sections overlapped_end_time for a teacher" do
    before do 
      sec1 = @sec.dup
      sec1.save
      @sec.name = "overlapped_section"
      @sec.start_time = '05:00:00'
      @sec.end_time = '11:00:00'
    end
    it {should_not be_valid}
  end

  #unit 9-3: test for section overlapped_start_end_time for a teacher
  describe "when sections overlapped_start_end_time for a teacher" do
    before do 
      sec1 = @sec.dup
      sec1.save
      @sec.name = "overlapped_section"
      @sec.start_time = '05:00:00'
      @sec.end_time = '21:00:00'
    end
    it {should_not be_valid}
  end

  #unit 9-4: test for section overlapped with ovevlapped date for a teacher
  describe "when sections overlapped_date_time for a teacher" do
    before do 
      sec1 = @sec.dup
      sec1.save
      @sec.name = "overlapped_section"
      @sec.start_time = '05:00:00'
      @sec.end_time = '21:00:00'
      @sec.start_date =' 2011-11-22'
      @sec.end_date = '2011-11-22'
      @sec.section_type = "C"
    end
    it {should_not be_valid}
  end

  #unit 9-5: test for section overlapped with same day for a teacher
  describe "when sections overlapped_date_time_different_type_B for a teacher" do
    before do 
      sec1 = @sec.dup
      sec1.save
      @sec.name = "overlapped_section"
      @sec.day = 'SUNDAY'
      @sec.start_time = '05:00:00'
      @sec.end_time = '21:00:00'
      @sec.start_date =' 2011-11-19'
      @sec.end_date = '2011-11-27'
      @sec.section_type = "B"
    end
    it {should be_valid}
  end

  #unit 9-6: test for section overlapped with different teachers
  describe "when sections overlapped for different teachers" do
    before do 
      sec1 = @sec.dup
      sec1.save
      @sec.name = "overlapped_section"
      @sec.teacher = 'SUCKER last'
      @sec.start_time = '05:00:00'
      @sec.end_time = '21:00:00'
      @sec.start_date =' 2011-11-14'
      @sec.end_date = '2011-11-24'
    end
    it {should be_valid}
  end

  describe "when invalid section_type A" do
    context "when invalid start_date" do
      before do
        @sec.start_date = "2013-04-19"
      end
      it { should_not be_valid }
    end
    
    context "when invalid end_date" do
      before do
        @sec.end_date = "2013-04-19"
      end
      it { should_not be_valid }
    end
    
    context "when invalid duration" do
      before do
        @sec.end_date = "2011-11-18"
      end
      it { should_not be_valid }
    end
  end

  describe "section_type B" do
    context "when it's valid" do
      before do
        @sec.start_date = "2013-04-20"
        @sec.end_date = "2013-04-28"
        @sec.section_type = "B"
      end
      it { should be_valid }
    end

    context "when invalid start_date" do
      before do
        @sec.start_date = "2013-04-19"
        @sec.section_type = "B"
      end
      it { should_not be_valid }
    end
    
    context "when invalid end_date" do
      before do
        @sec.end_date = "2013-04-19"
        @sec.section_type = "B"
      end
      it { should_not be_valid }
    end
    
    context "when invalid duration" do
      before do
        @sec.start_date = "2013-11-20"
        @sec.end_date = "2013-11-21"
        @sec.section_type = "B"
      end
      it { should_not be_valid }
    end
  end


  describe "section_type C" do
    context "when it's valid" do
      before do
        @sec.start_date = "2013-04-20"
        @sec.end_date = "2013-04-20"
        @sec.day = "Saturday"
        @sec.section_type = "C"
      end
      it { should be_valid }
    end

    context "when invalid start_date" do
      before do
        @sec.start_date = "2013-04-19"
        @sec.section_type = "C"
      end
      it { should_not be_valid }
    end
    
    context "when invalid end_date" do
      before do
        @sec.end_date = "2013-04-19"
        @sec.section_type = "C"
      end
      it { should_not be_valid }
    end
    
    context "when invalid day" do
      before do
        @sec.start_date = "2013-11-20"
        @sec.end_date = "2013-11-20"
        @sec.day = "Monday"
        @sec.section_type = "C"
      end
      it { should_not be_valid }
    end
  end



end
