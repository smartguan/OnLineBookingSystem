require 'spec_helper'

describe MemberStudent do
  before do 
    @user = FactoryGirl.create(:member_student) 
  end
  it { @user.should be_valid }
end
