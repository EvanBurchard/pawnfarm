require 'spec_helper'

describe Pawn do
  it { should have_db_column(:user_id).of_type(:integer).with_options(:null => false) }
  it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:twitter_username).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:twitter_password).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:frequency).of_type(:integer) }
  it { should have_db_column(:schedule).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }
  
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :name => "value for name",
      :twitter_username => "value for twitter_username",
      :twitter_password => "value for twitter_password",
      :frequency => 1,
      :schedule => "value for schedule"
    }
  end

  it "should create a new instance given valid attributes" do
    Pawn.create!(@valid_attributes)
  end
end
