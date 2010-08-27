require 'spec_helper'

describe TweetScheme do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :title => "tweet_scheme",
      :type => "tweet_scheme",
      :tweet_prompt => "value for tweet_prompt",
      :tweet_prompt_relationship => "value for tweet_prompt_relationship",
      :prompt => "value for prompt"
    }
  end

  it "should create a new instance given valid attributes" do
    TweetScheme.create!(@valid_attributes)
  end
end
