class MocksController < ApplicationController
SUCCESS = 1
  	def testProfile
  		@user = User.new(first: 'hello', last: 'hello', email:'yoohoo@yoohoo.com', password:'yellow', password_confirmation:'yellow', dob:'05/05/05', zip:12345, admin:false);
    	respond_to do |format|
      		format.json { render json: { errCode: SUCCESS, user: @user } }
    	end
  	end

end
