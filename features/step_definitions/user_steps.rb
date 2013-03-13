#######################################################################
######################  Givens (setups) ###############################
#######################################################################

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

Given(/^I am accessing the "(.*?)" form$/) do |name|
  @currform = "#{name}" 
end

Given(/^I am a valid user$/) do
  @user = FactoryGirl.create(:user)
end


Given(/^I fill in my "(.*?)"$/) do |field_name|
  page.fill_in "user_#{field_name}", :with => "#{@user[field_name.to_sym]}"
end

Given(/^I have filled in a valid form$/) do
  page.fill_in 'user_first', 			 	 :with => 'boom'
  page.fill_in 'user_last', 			 	 :with => 'baby'
  page.fill_in 'user_email',				 :with => 'doodoo@baby.com'
  page.fill_in 'user_dob',				 	 :with => '5/5/2005'
  page.fill_in 'user_zip',					 :with => '96782'
  page.fill_in 'user_password',				 :with => 'secret12345'
  page.fill_in 'user_password_confirmation', :with => 'secret12345'
end
#######################################################################
######################  Whens (triggers) ##############################
#######################################################################
When(/I hit the "(.*?)" button$/) do |button|
  page.click_button button
end

#######################################################################
####################  Thens (validity checeks) ########################
#######################################################################

Then(/^I should see an input field for "(.*?)"$/) do |field_name|
  field_name = "user_#{field_name}"
  page.should have_field (field_name)
end

Then(/^I should see an error displaying keyword "(.*?)"$/) do |err|
  page.should have_content err #a display with error msg occured
end

Then(/^I should be redirected user's profile$/) do
  page.should have_content "users#show"
end

Then(/^I should not see an error displaying "(.*?)"$/) do |err|
  page.should_not have_content err
end
