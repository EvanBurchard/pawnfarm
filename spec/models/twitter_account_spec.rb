require 'spec_helper'

describe TwitterAccount do
  it { should belong_to(:pawn) }
  it { should validate_presence_of(:pawn_id)}
  it { should validate_presence_of(:username)}
  it { should validate_presence_of(:password)}

  it { should have_db_column(:friends).of_type(:string) }
  it { should have_db_column(:followers).of_type(:string) }
  it { should have_db_column(:friend_count).of_type(:integer) }
  it { should have_db_column(:follower_count).of_type(:integer) }
  it { should have_db_column(:last_tweeted).of_type(:datetime) }
  it { should have_db_column(:status).of_type(:string) }
  it { should have_db_column(:pawn_id).of_type(:integer) }
  it { should have_db_column(:username).of_type(:string) }
  it { should have_db_column(:password).of_type(:string) }
  it { should have_db_column(:access_key).of_type(:string) }
  it { should have_db_column(:access_secret).of_type(:string) }
  
  before(:each) do
    "api.twitter.com/oauth/authorize?oauth_token=b2lcemfpExbSBi2wFc0NiSg3vqeAulCoKaE7vR3qjI"
    @valid_attributes = {
      :friends => "value for friends",
      :followers => "value for followers",
      :friend_count => 1,
      :follower_count => 1,
      :last_tweeted => Time.now,
      :status => "value for status",
      :pawn_id => 1,
      :username => "value for username",
      :password => "value for password",
      :access_key => "value for access_key",
      :access_secret => "value for access_secret"
    }
    @twitter_account = TwitterAccount.new(@valid_attributes)
    @twitter_account.stub!(:authorize_url).and_return(@authorize_url = "api.twitter.com/oauth/authorize?oauth_token=b2lcemfpE")
  end

  it "should create a new instance given valid attributes" do
    @twitter_account.save
  end
  
end
