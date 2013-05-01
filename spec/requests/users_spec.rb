require 'spec_helper'

describe "Users" do
	# describe "Creating a User FRONTEND", js: true do
 #      it "should be a successful create user" do
 #        visit "/"
 #        click_link_or_button "Create an Account"  #, :href => "#create-user"
 #        fill_in "create-first", with: "first"
 #        fill_in "create-last", with: "last"
        
 #        fill_in "create-email",                 with: "new@user.net"
 #        fill_in "create-password",              with: "password"
 #        fill_in "create-password_confirmation", with: "password"
 #        fill_in "create-dob",                   with: "00/00/0000"

 #        fill_in "create-residence-address", with: "1456 Akeukeu St."
 #        fill_in "create-residence-city",    with: "Crazy City"
 #        fill_in "create-residence-zip",     with: "12345"
        
 #        click_link_or_button "Next"

 #        fill_in "create-contacts-first-name",       with:"Aunty May"
 #        fill_in "create-contacts-first-primary",    with:"1111111111"
 #        fill_in "create-contacts-first-secondary",  with:"2222222222"
 #        fill_in "create-contacts-second-name",      with:"Uncle Ben"
 #        fill_in "create-contacts-second-primary",   with:"3333333333"
 #        fill_in "create-contacts-second-secondary", with:"4444444444"
        
 #        click_link_or_button "Next"

 #        # click_link_or_button "create-user-button"
 #        find_by_id("create-user-button").click
 #        @user_hash = { first: "first", last: "last", dob: "00/11/2222", 
 #                       residence: { address: "123 a st.", city: "b-town", 
 #                                    zip: "12345" },
 #                       contacts: { first: { name: "mom", 
 #                                            primary: "(123) 456-7890",
 #                                            secondary: "(098) 765-4321" },
 #                                   second: { name: "dad", 
 #                                             primary: "(123) 456-7890",
 #                                             secondary: "(098) 765-4321" } },
 #                       email: "abc@def.org",
 #                       gender: "other", skill: "intermediate",
 #                       extra: "This is extra info",
 #                       password: "password",
 #                       format: :json }
 #        sleep(2)
 #        page.should have_selector('#create-user-success', visible: true)
 #        page.should have_selector('#WelcomeDropDown', visible: true)
 #        page.should have_selector('#SignDropDown', visible: false)
 #        page.should have_selector('#CreateAccountButton', visible: false)
 #      end
 #  end
	describe "A User is signed in FRONTEND", js: true do
  	it "should allow user to log in" do
  		# @student = FactoryGirl.create(:member_student)
  		# visit '/'
  		# find_by_id("SignDropDown").click
  		# click_link_or_button "Sign In"
  		# fill_in "login-email", with: @student.email
  		# fill_in "login-password", with: @student.password
  		# click_link_or_button "login-button"
  		# sleep(2)
    #     page.should have_selector('#WelcomeDropDown', visible: true)
    #     page.should have_selector('#SignDropDown', visible: false)
    #     page.should have_selector('#CreateAccountButton', visible: false)
  	end

  	# it "should display correct profile information" do

		it "should on load show the users details" do
			# sleep(5)
			# post '/Users/login', { email: @student.email, password: @student.password, format: :json }
			# post '/Users/login', { email: "abc@def.org", password: "password", format: :json }
			@student = FactoryGirl.create(:member_student)
			visit '/'
			within(:css, ".navbar.navbar-inverse.nav.navbar-fixed-top") do
		      	find_by_id("SignDropDown").click
		  		click_link_or_button "Sign In"

		  		fill_in "login-email", with: @student.email
		  		fill_in "login-password", with: @student.password
		  		click_link_or_button "login-button"
		  		sleep(2)
		  		# describe "Correct Navbar" do
		  		# 	it "should display SIGNED IN USER Navbar" do
				page.should have_selector('#WelcomeDropDown', visible: true)
	    		page.should have_selector('#SignDropDown', visible: false)
	    		page.should have_selector('#CreateAccountButton', visible: false)
		        # 	end
		        # end
		        click_link("Welcome, User")
		        click_link("My Info")
		        current_path.should == '/Users/show'
		        sleep(8);
	    	end
	    	within(:css, ".navbar.navbar-inverse.nav.navbar-fixed-top") do
				page.should have_selector('#WelcomeDropDown', visible: true)
	    		page.should have_selector('#SignDropDown', visible: false)
	    		page.should have_selector('#CreateAccountButton', visible: false)
	    end

			# page.find('#foo').find('.bar')
			# request.cookies[:user_id] = @student.id
			# find_by_id("WelcomeDropDown").click
			# click_link("Welcome, User")
			# click_link ("My Info")
			# current_path.should == "/Users/show"


			page.should have_content(@student.first)
			page.should have_content(@student.last)
			page.should have_content(@student.email)
			page.should have_content(@student.dob)
			# end
			# it "should on load show the users residence" do
			page.should have_content(@student.address)
			page.should have_content(@student.city)
			page.should have_content(@student.zip)
		end
	  	
	end
  	# end


 # 	it "should on show admin" do
	# 	@student = FactoryGirl.create(:member_student)
	# 	visit '/admin'
	# 	# request.cookies[:user_id] = @student.id
	# 	# find_by_id("WelcomeDropDown").click
	# 	# click_link("Welcome, User")
	# 	# click_link ("My Info")
	# 	# current_path.should == "/Users/show"
		
	# 	page.should have_selector('#CreateSection')
	# 	# page.should have_css('.tabbable')
	# 	# page.should have_css('.tabbable')

	# 	# page.should have_selector('#WelcomeDropDown', visible: true)
	# 	# page.should have_selector('#SignDropDown', visible: false)
 #  		# page.should have_selector('#CreateAccountButton', visible: false)
		
	# end

	# describe "Updating User Password FRONTEND", js: true do
 #    	it "should return BAD_CREDENTIALS" do
 #      visit "/"
 #      click_link_or_button "Create an Account"  #, :href => "#create-user"
 #      fill_in "create-first", with: "first"
 #      fill_in "create-last", with: "last"
      
 #      fill_in "create-email",                 with: "new@user.net"
 #      fill_in "create-password",              with: "password"
 #      fill_in "create-password_confirmation", with: "password"
 #      fill_in "create-dob",                   with: "00/00/0000"

 #      fill_in "create-residence-address", with: "1456 Akeukeu St."
 #      fill_in "create-residence-city",    with: "Crazy City"
 #      fill_in "create-residence-zip",     with: "12345"
      
 #      click_link_or_button "Next"

 #      fill_in "create-contacts-first-name",       with:"Aunty May"
 #      fill_in "create-contacts-first-primary",    with:"1111111111"
 #      fill_in "create-contacts-first-secondary",  with:"2222222222"
 #      fill_in "create-contacts-second-name",      with:"Uncle Ben"
 #      fill_in "create-contacts-second-primary",   with:"3333333333"
 #      fill_in "create-contacts-second-secondary", with:"4444444444"
      
 #      click_link_or_button "Next"

 #      # click_link_or_button "create-user-button"
 #      find_by_id("create-user-button").click
 #      # @user_hash = { first: "first", last: "last", dob: "00/11/2222", 
 #      #                residence: { address: "123 a st.", city: "b-town", 
 #      #                             zip: "12345" },
 #      #                contacts: { first: { name: "mom", 
 #      #                                     primary: "(123) 456-7890",
 #      #                                     secondary: "(098) 765-4321" },
 #      #                            second: { name: "dad", 
 #      #                                      primary: "(123) 456-7890",
 #      #                                      secondary: "(098) 765-4321" } },
 #      #                email: "abc@def.org",
 #      #                gender: "other", skill: "intermediate",
 #      #                extra: "This is extra info",
 #      #                password: "password",
 #      #                format: :json }
 #      sleep(2)
      
 #      page.should have_selector('#create-user-success', visible: true)

      
 #      ################## User is Created ################### 
 #      click_link_or_button
end
