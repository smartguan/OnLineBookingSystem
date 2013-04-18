class Instructor < User
  attr_accessible :section_id

  has_many :sections, :order => "start_date ASC", :inverse_of => :instructor
end
