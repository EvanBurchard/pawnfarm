require 'spec_helper'

describe TurkForm do
  it { should belong_to(:execution) }
  it { should have_db_column(:execution_id).of_type(:integer) }
  it { should have_db_column(:url).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  before(:each) do
    @valid_attributes = {
      :url => "value for url"
    }
  end

  it "should create a new instance given valid attributes" do
    TurkForm.create!(@valid_attributes)
  end
end
