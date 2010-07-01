require 'spec_helper'

describe AtScheme do
  it { should validate_presence_of(:target) }
  
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :type => "at_scheme",
      :title => "at_scheme",
      :tweet_prompt => "value for tweet_prompt",
      :tweet_prompt_relationship => "value for tweet_prompt_relationship",
      :prompt => "value for prompt",
      :target => "value for target",
      :target_relationship => "value for target_relationship"
    }
  end

  it "should create a new instance given valid attributes" do
    AtScheme.create!(@valid_attributes)
  end
end
