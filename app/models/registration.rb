class Registration < ActiveRecord::Base
  attr_accessible :day, :description, :end_date, :end_time, :enroll_cur, :enroll_max, :start_date, :start_time, :teacher, :waitlist_cur, :waitlist_max
end
