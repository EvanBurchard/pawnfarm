require 'spec_helper'

describe Execution do
  it { should belong_to(:scheme) }
  it { should belong_to(:pawn) }
  
  it { should have_db_column(:state).of_type(:string) }
  it { should have_db_column(:candidate_a).of_type(:string) }
  it { should have_db_column(:candidate_b).of_type(:string) }
  it { should have_db_column(:winner).of_type(:string) }
  it { should have_db_column(:scheme_id).of_type(:integer) }
  it { should have_db_column(:pawn_id).of_type(:integer) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }
    
  before(:each) do
    @valid_attributes = {
      :scheme_id => 1,
      :pawn_id => 1,
      :state => "value for state",
      :candidate_a => "value for candidate_a",
      :candidate_b => "value for candidate_b",
      :winner => "value for winner"
    }
  end

  it "should create a new instance given valid attributes" do
    Execution.create!(@valid_attributes)
  end
end
