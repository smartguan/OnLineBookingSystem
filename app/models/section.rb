class Section < ActiveRecord::Base
  attr_accessible :name, :day, :description, :end_date, :end_time, :enroll_cur, :enroll_max, :start_date, :start_time, :teacher, :waitlist_cur, :waitlist_max, :section_type, :lesson_type, :instructor_id, :student_id

  has_many :registrations
  has_many :students, :through => :registrations, :order => "first ASC", :uniq => true

  belongs_to :instructor, :inverse_of => :sections

  before_validation do |section| 
  #  section.name = name.upcase
    section.day = day.upcase
    section.teacher = teacher.upcase
    section.section_type = section_type.upcase
    section.lesson_type = lesson_type.upcase
  end

  #validates :name, presence:true, length: {maximum: 20},
  #                 uniqueness: {case_sensitive: false}
  validates :day, presence:true
  validates :teacher, presence:true
  #validates :description, presence:true
  validates :end_date, presence:true
  validates :end_time, presence:true
  validates :enroll_cur, presence:true
  validates :enroll_max, presence:true
  validates :start_date, presence:true
  validates :start_time, presence:true
  validates :waitlist_cur, presence:true
  validates :waitlist_max, presence:true
  validates :section_type, presence:true
  validates :lesson_type, presence:true

  
  #validate for inclusion for day
  validates_inclusion_of :day, :in => ['SUNDAY', 'MONDAY', 'TUESDAY', 
                                      'WEDNESDAY', 'THURSDAY', 'FRIDAY',
                                      'SATURDAY']
  #validate for inclusion for section_type
  validates_inclusion_of :section_type, :in => ['A', 'B', 'C'] 
  #validate for inclusion for lesson_type
  validates_inclusion_of :lesson_type, :in => ['PRIVATE', 'PRE-COMP', 'GROUP']
  
  #validate :teacher_has_first_and_last_name
  validate :start_time_must_be_before_end_time
  validate :start_date_must_be_before_end_date
  validate :enroll_cur_must_be_less_or_equal_enroll_max
  validate :waitlist_cur_must_be_less_or_equal_waitlist_max
  validate :section_not_overlapped_for_a_teacher
  validate :date_must_match_section_type

  #validate teacher name has first and last
  def teacher_has_first_and_last_name
    self.errors.add :teacher, 'teacher_name_invalid' unless
      teacher.include?(" ")
  end
  
  #validate end_time > start_time
  def start_time_must_be_before_end_time
    self.errors.add :start_time, 'has to be before end time' unless 
        start_time < end_time
  end

  #validate end_time > start_time
  def start_date_must_be_before_end_date
    self.errors.add :start_date, 'has to be before end date' unless 
        start_date <= end_date
  end

  #validate end_time > start_time
  def enroll_cur_must_be_less_or_equal_enroll_max
    self.errors.add :enroll_cur, 'has to be less or equal to enroll_max' unless 
        enroll_cur <= enroll_max
  end

  #validate end_time > start_time
  def waitlist_cur_must_be_less_or_equal_waitlist_max
    self.errors.add :waitlist_cur, 'has to be less or equal to waitlist_max' unless 
        waitlist_cur <= waitlist_max
  end

  #validate no section overlop for a teacher
  def section_not_overlapped_for_a_teacher
    if Section.where("((:start_time BETWEEN start_time AND end_time) OR 
                           (:end_time BETWEEN start_time AND end_time) OR 
                           (:start_time <= start_time AND :end_time >= end_time)) AND
                            ((:start_date BETWEEN start_date AND end_date) OR 
                            (:end_date BETWEEN start_date AND end_date) OR 
                            (:start_date <= start_date AND :end_date >= end_date)) AND
                              (:section_type = section_type AND 
                                :name != name AND :teacher = teacher)",
                          :start_time => start_time, :end_time => end_time, 
                          :start_date => start_date, :end_date => end_date,
                          :section_type => section_type, :name => name, 
                          :teacher => teacher).first != nil
      self.errors.add :teacher, 'section_overlapped'
    end
  end

  #validate date match section_type
  def date_must_match_section_type
    days = ['SUNDAY', 'MONDAY', 'TUESDAY', 
            'WEDNESDAY', 'THURSDAY', 'FRIDAY',
            'SATURDAY']
    
    if not  
      ((section_type == "A" and start_date.to_date.monday? and 
                  end_date.to_date.thursday? and 
                  (end_date.to_date - start_date.to_date == 10)) or
      (section_type == "B" and start_date.saturday? and 
                  end_date.to_date.sunday? and 
                  (end_date.to_date - start_date.to_date == 8)) or
      (section_type == "C" and start_date == end_date and 
                              days[start_date.to_date.wday]== day))

      self.errors.add :section_type, 'date not match section_type'
    end
  end

  

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |product|
        csv << product.attributes.values_at(*column_names)
      end
    end
  end
end
