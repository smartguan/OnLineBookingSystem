require 'spec_helper'

describe Instructor do
  before do 
    @user = FactoryGirl.create(:instructor) 
  end
  it { @user.should be_valid }
end
