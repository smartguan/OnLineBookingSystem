# require 'spec_helper'

# describe UsersUpdatePassword do


# 	# SUCCESS = 1
# 	# FIRST_NOT_VALID = 101
# 	# LAST_NOT_VALID = 102
# 	# EMAIL_NOT_VALID = 103
# 	# PASS_NOT_VALID = 104
# 	# PASS_NOT_MATCH = 109
# 	# DOB_NOT_VALID = 105
# 	# ZIP_NOT_VALID = 106
# 	# USER_EXISTS = 107
# 	# BAD_CREDENTIALS = 108

# 	# describe "updating user's password", :js => true do
# 	# 	before(:each) do
# 	# 		visit "users/update_password"
# 	# 	end

# 	# 	describe "leaving empty fields" do
# 	# 		before(:each) do 
# 	# 	    	fill_in "old-password", with: "oldpassword"
# 	# 	    	fill_in "password", with: "newpassword"
# 	# 	    	fill_in "password-confirm", with: "newpassword"
# 	# 	    end

# 	# 	  	it "should render empty old password error" do
# 	# 	  		fill_in "old-password", with: ""
# 	# 	  		click_button "test-update"
# 	# 	    	page.should have_content "invalid"
# 	# 	  	end

# 	# 	  	it "should render empty new password error" do
# 	# 	  		fill_in "password", with: ""
# 	# 	  		click_button "test-update"
# 	# 	    	page.should have_content "invalid"
# 	# 	  	end

# 	# 	  	it "should render empty new password error" do
# 	# 	  		fill_in "password-confirm", with: ""
# 	# 	  		click_button "test-update"
# 	# 	    	page.should have_content "invalid"
# 	# 	  	end
# 	# 	end

# 	# 	describe "passwords do not match" do

# 	# 	end


# 	# end




# end