require 'spec_helper'

describe Scheme do
  it { should belong_to(:pawn) }
  
  it { should have_db_column(:type).of_type(:string) }
  it { should have_db_column(:pawn_id).of_type(:integer) }
  it { should have_db_column(:random_interval).of_type(:boolean) }
  it { should have_db_column(:frequency).of_type(:integer) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }
  it { should have_db_column(:tweet_prompt) }
  it { should have_db_column(:tweet_prompt_relationship) }
  it { should have_db_column(:prompt) }
  it { should have_db_column(:target) }
  it { should have_db_column(:target_relationship) }        

  before(:each) do
    @valid_attributes = {
      :pawn_id => 1,
      :random_interval => false,
      :frequency => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Scheme.create!(@valid_attributes)
  end
end
