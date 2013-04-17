require 'spec_helper'

describe Admin do
  before do 
    @user = FactoryGirl.create(:admin)
  end
  it { @user.should be_valid }
end
