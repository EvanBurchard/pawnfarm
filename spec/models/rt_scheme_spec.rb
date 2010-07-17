require 'spec_helper'

describe RtScheme do
  it { should validate_presence_of(:target_account) }
  
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :title => "rt_scheme",
      :type => "rt_scheme",
      :target_account => "value for target",
      :target_relationship => "value for target_relationship"
    }
  end

  it "should create a new instance given valid attributes" do
    RtScheme.create!(@valid_attributes)
  end
end
