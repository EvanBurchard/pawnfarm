require 'spec_helper'

describe TwitterAccount do
  it { should belong_to(:pawn) }

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
  end

  it "should create a new instance given valid attributes" do
    TwitterAccount.create!(@valid_attributes)
  end
end
