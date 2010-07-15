require 'spec_helper'

describe TurkForm do
  it { should belong_to(:execution) }
  it { should have_db_column(:execution_id).of_type(:integer) }
  it { should have_db_column(:url).of_type(:string) }
  it { should have_db_column(:body).of_type(:text) }
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
  it "should have access to the execution's scheme's prompt" do
    @scheme = AtScheme.create!(:prompt => "some prompt", :id => 1, :user_id => 1, :title => 1, :target => "some target")
    @turk_form = TurkForm.create!(@valid_attributes)
    @turk_form.stub!(:prompt).and_return(@scheme.prompt)
    @turk_form.prompt.should == "some prompt"
  end
end
