class Registration < ActiveRecord::Base
  attr_accessible :name, :day, :description, :end_date, :end_time, :enroll_cur, :enroll_max, :start_date, :start_time, :teacher, :waitlist_cur, :waitlist_max

  #has_and_belongs_to_many :users

  before_validation do |registration| 
    registration.name = name.upcase
    registration.day = day.upcase
    registration.teacher = teacher.upcase
  end

  validates :name, presence:true, length: {maximum: 20},
                   uniqueness: {case_sensitive: false}
  validates :day, presence:true
  validates :teacher, presence:true
  validates :description, presence:true
  validates :end_date, presence:true
  validates :end_time, presence:true
  validates :enroll_cur, presence:true
  validates :enroll_max, presence:true
  validates :start_date, presence:true
  validates :start_time, presence:true
  validates :waitlist_cur, presence:true
  validates :waitlist_max, presence:true

  #validate for inclusion for day
  validates_inclusion_of :day, :in => ['SUNDAY', 'MONDAY', 'TUESDAY', 
                                      'WEDNESDAY', 'THURSDAY', 'FRIDAY',
                                      'SATURDAY']
  
  validate :start_time_must_be_before_end_time
  validate :start_date_must_be_before_end_date
  validate :enroll_cur_must_be_less_or_equal_enroll_max
  validate :waitlist_cur_must_be_less_or_equal_waitlist_max
  validate :section_not_overlapped_for_a_teacher

  #validate end_time > start_time
  def start_time_must_be_before_end_time
    self.errors.add :start_time, 'has to be before end time' unless 
        start_time < end_time
  end

  #validate end_time > start_time
  def start_date_must_be_before_end_date
    self.errors.add :start_date, 'has to be before end date' unless 
        start_date < end_date
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
    if Registration.where("((:start_time BETWEEN start_time AND end_time) OR 
                           (:end_time BETWEEN start_time AND end_time) OR 
                           (:start_time <= start_time AND :end_time >= end_time)) AND
                            ((:start_date BETWEEN start_date AND end_date) OR 
                            (:end_date BETWEEN start_date AND end_date) OR 
                            (:start_date <= start_date AND :end_date >= end_date)) AND
                              (:day == day AND :name != name AND :teacher == teacher)",
                          :start_time => start_time, :end_time => end_time, 
                          :start_date => start_date, :end_date => end_date,
                          :day => day, :name => name, :teacher => teacher).first != nil
      self.errors.add :teacher, 'section_overlapped'
    end
  end



end
