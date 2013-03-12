######################  Givens (setups) ##############################
Given (/^(?:|I )am on the (.+) page$/) do |page_name|
  if page_name == 'home'
    visit '/'
  else
    visit page_name
  end
end

Given(/^I leave the input field for "(.*?)" blank$/) do |field_name|
  	field_name = "user_#{field_name}"
  	page.fill_in field_name, :with => ' '
end

Given(/^I have filled in a valid form$/) do
  # @user = FactoryGirl.build(:user)
  # field_names = ['first','last', 'email', 'dob', 'zip', 'password']
  # # field_names.map! {|attr| "user_#{attr}" }
  
  # field_names.each do |field_name|
  #     page.fill_in "user_#{field_name}", :with => @user[(field_name.to_sym)]
  # end
  page.fill_in 'user_first', 			 	 :with => 'boom'
  page.fill_in 'user_last', 			 	 :with => 'baby'
  page.fill_in 'user_email',				 :with => 'doodoo@baby.com'
  page.fill_in 'user_dob',				 	 :with => '5/5/05'
  page.fill_in 'user_zip',					 :with => '96782'
  page.fill_in 'user_password',				 :with => 'secret'
  page.fill_in 'user_password_confirmation', :with => 'secret'
end

######################  Whens (triggers) ##############################
When(/I hit the "(.*?)" button$/) do |button|
  page.click_button button
end

####################  Thens (validity checeks) ########################
Then(/^I should see an input field for "(.*?)"$/) do |field_name|
  	field_name = "user_#{field_name}"
    page.should have_field (field_name)
end

Then(/^I should see an error displaying keyword "(.*?)"$/) do |err|
	page.should have_content err #a display with error msg occured
end
