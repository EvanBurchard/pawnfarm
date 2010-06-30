require 'spec_helper'

describe Scheme do
  it { should belong_to(:pawn) }
  it { should belong_to(:scheme_type) }
  
  it { should have_db_column(:scheme_type_id).of_type(:integer) }
  it { should have_db_column(:pawn_id).of_type(:integer) }
  it { should have_db_column(:target).of_type(:string) }
  it { should have_db_column(:prompt).of_type(:string) }
  it { should have_db_column(:random_interval).of_type(:boolean) }
  it { should have_db_column(:frequency).of_type(:integer) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }
  

  before(:each) do
    @valid_attributes = {
      :scheme_type_id => 1,
      :pawn_id => 1,
      :target => "value for target",
      :prompt => "value for prompt",
      :random_interval => false,
      :frequency => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Scheme.create!(@valid_attributes)
  end
end
