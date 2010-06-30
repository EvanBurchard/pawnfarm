require 'spec_helper'

describe RtScheme do
  before(:each) do
    @valid_attributes = {
      :target => "value for target",
      :target_relationship => "value for target_relationship"
    }
  end

  it "should create a new instance given valid attributes" do
    RtScheme.create!(@valid_attributes)
  end
end
