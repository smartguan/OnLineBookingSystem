require 'factory_girl'

FactoryGirl.define do
	factory :user do |f|
		f.first 				 'boom'
		f.last 					 'baby'
		f.email 				 'doodoo@baby.com'
		f.dob 					 '05/05/1995'
		f.zip 	 				  96782
		f.password		 		 'secret'
		f.password_confirmation  'secret'
	end
end