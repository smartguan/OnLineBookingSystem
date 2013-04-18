class Student < User
  
  has_many :registrations
  has_many :sections, :through => :registrations, :order => "day ASC", :uniq => true
  
end
