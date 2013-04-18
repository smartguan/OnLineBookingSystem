class Registration < ActiveRecord::Base
  attr_accessible :payment_received, :waitlist_place, :section_id, :user_id

  belongs_to :student
  belongs_to :section
end
