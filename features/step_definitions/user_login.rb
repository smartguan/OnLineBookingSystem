Given(/^I am accessing the "(.*?)" form$/) do |name|
	@currform = "#{name}" 
end

Given(/^I am a valid user$/) do
  @user = FactoryGirl.create(:user)
end


Given(/^I fill in my "(.*?)"$/) do |field_name|
  page.fill_in "user_#{field_name}", :with => "#{@user[field_name.to_sym]}"
end


Then(/^I should be redirected user's profile$/) do
  current_path.should == "/users/profile/"
end

Then(/^I should not see an error displaying "(.*?)"$/) do |err|
	page.should_not have_content err
end

