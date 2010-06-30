require 'spec_helper'

describe RtScheme do
  it { should validate_presence_of(:target) }
  
  before(:each) do
    @valid_attributes = {
      :pawn_id => 1,
      :type => "rt_scheme",
      :target => "value for target",
      :target_relationship => "value for target_relationship"
    }
  end

  it "should create a new instance given valid attributes" do
    RtScheme.create!(@valid_attributes)
  end
end
