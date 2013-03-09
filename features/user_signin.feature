Feature: Sign up new User - all of the steps necessary for adding a new user

Background:
	Given I am on the add page

Scenario: Viewing the Sign up Form
	Then I should see an input field for "first"
	And  I should see an input field for "last"
	And  I should see an input field for "email"
	And  I should see an input field for "zip"
	And  I should see an input field for "dob"
	And  I should see an input field for "password"
	And  I should see an input field for "password_confirmation"

Scenario: Leaving fields blank
	And  I have filled in a valid form
	But  I leave the input field for "firstname" blank
	When I hit the "Create User" button
	Then I should see an error displaying keyword "blank"