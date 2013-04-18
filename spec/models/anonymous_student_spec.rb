require 'spec_helper'

describe AnonymousStudent do
  before do 
    @user = FactoryGirl.create(:anonymous_student)
  end
  it { @user.should be_valid }
end
