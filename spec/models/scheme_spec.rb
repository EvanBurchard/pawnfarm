require 'spec_helper'

describe Scheme do
  it { should have_and_belong_to_many(:pawns) }
  it { should have_many(:executions).dependent(:destroy) }
  it { should belong_to(:user) }

  # it { should validate_inclusion_of(:type, :in => %w(rt_scheme, at_scheme, tweet_scheme  )}
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:user_id) }
  
  it { should have_db_column(:title).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:description).of_type(:string) }
  it { should have_db_column(:type).of_type(:string) }
  it { should have_db_column(:user_id).of_type(:integer) }
  it { should have_db_column(:random_interval).of_type(:boolean) }
  it { should have_db_column(:frequency).of_type(:integer) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }
  it { should have_db_column(:tweet_prompt) }
  it { should have_db_column(:tweet_prompt_relationship) }
  it { should have_db_column(:prompt) }
  it { should have_db_column(:target) }
  it { should have_db_column(:target_relationship) }        



  describe "an at scheme" do
    describe "without a friend/follower tweet_prompt_relationship" do
      before(:each) do
        @valid_attributes = {:title => "scheme title", 
                             :user => (@user = mock_model(User, :id => 1)), 
                             :target => "some_target_account",
                             :tweet_prompt => "some_twitter_account"}
        @scheme = AtScheme.new(@valid_attributes)
      end

      it "should create a new instance given valid attributes" do
        @scheme.save
      end
      it "should have a status to tweet" do
        @scheme.save
        @scheme.stub!(:get_status).and_return("latest user status")
        @status_to_tweet = @scheme.get_status_for_tweet_prompt
        @status_to_tweet.should_not be nil
      end

      it "should receive get_status" do
        @scheme.save
        @scheme.should_receive(:get_status).with("some_twitter_account").and_return("latest user status")
        @status_to_tweet = @scheme.get_status_for_tweet_prompt
      end
    end
    describe "with a friend tweet_prompt_relationship" do
      before(:each) do
        @valid_attributes = {:title => "scheme title", 
                             :user => (@user = mock_model(User, :id => 1)), 
                             :target => "some_twitter_account",
                             :tweet_prompt => "some_twitter_account",
                             :tweet_prompt_relationship => "friends"}
        @scheme = AtScheme.new(@valid_attributes)
        @scheme.stub!(:random_friend).and_return("some_friend_account")        
      end

      it "should create a new instance given valid attributes" do
        @scheme.save
      end
      it "should have a status to tweet" do
        @scheme.save
        @scheme.stub!(:get_status).and_return("latest user status")
        @status_to_tweet = @scheme.get_status_for_tweet_prompt
        @status_to_tweet.should_not be nil
      end

      it "should receive get_status with friend account" do
        @scheme.save
        @scheme.should_receive(:get_status).with("some_friend_account").and_return("latest user status")
        @status_to_tweet = @scheme.get_status_for_tweet_prompt
      end
      it "should receive random_friend" do
        @scheme.save
        @scheme.stub!(:get_status).and_return("latest friend status")
        @scheme.should_receive(:random_friend).and_return("some_friend_account")
        @status_to_tweet = @scheme.get_status_for_tweet_prompt
      end
      it "should receive random_friend status" do
        @scheme.save
        @scheme.stub!(:get_status).and_return("latest friend status")
        @scheme.should_receive(:get_status).and_return("latest friend status")
        @status_to_tweet = @scheme.get_status_for_tweet_prompt
      end
      
    end
    describe "with a follower tweet_prompt_relationship" do
      before(:each) do
        @valid_attributes = {:title => "scheme title", 
                             :user => (@user = mock_model(User, :id => 1)), 
                             :target => "some_twitter_account",
                             :tweet_prompt => "some_twitter_account",
                             :tweet_prompt_relationship => "followers"}
        @scheme = AtScheme.new(@valid_attributes)
        @scheme.stub!(:random_follower).and_return("some_follower_account")        
        
      end

      it "should create a new instance given valid attributes" do
        @scheme.save
      end
      it "should have a status to tweet" do
        @scheme.save
        @scheme.stub!(:get_status).and_return("latest user status")
        @status_to_tweet = @scheme.get_status_for_tweet_prompt
        @status_to_tweet.should_not be nil
      end

      it "should receive get_status with a follower account" do
        @scheme.save
        @scheme.should_receive(:get_status).with("some_follower_account").and_return("latest follower status")
        @status_to_tweet = @scheme.get_status_for_tweet_prompt
      end
      it "should receive random_follower" do
        @scheme.save
        @scheme.stub!(:get_status).and_return("latest follower status")
        @scheme.should_receive(:random_follower).and_return("some_follower_account")
        @status_to_tweet = @scheme.get_status_for_tweet_prompt
      end
      it "should receive random_follower status" do
        @scheme.save
        @scheme.stub!(:get_status).and_return("latest follower status")
        @scheme.should_receive(:get_status).and_return("latest follower status")
        @status_to_tweet = @scheme.get_status_for_tweet_prompt
      end
      
    end

  end
  
end
