require 'spec_helper'

describe Pawn do
  it { should belong_to(:user) }
  it { should have_many(:executions).dependent(:destroy) }
  it { should have_one(:twitter_account).dependent(:destroy) }
  it { should have_and_belong_to_many(:schemes) }
  it { should validate_presence_of(:name) }
  it { should have_db_column(:user_id).of_type(:integer).with_options(:null => false) }
  it { should have_db_column(:name).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:description).of_type(:string) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }
  it { should have_db_column(:active).of_type(:boolean) }
  
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :name => "value for name",
      :twitter_username => "value for twitter_username",
      :twitter_password => "value for twitter_password"

    }
  end

  it "should create a new instance given valid attributes" do
    Pawn.create!(@valid_attributes)
  end
  
  it "should have twitter account with proper name after pawn is created" do
    @pawn = Pawn.new(@valid_attributes)
    @pawn.save
    @pawn.setup_twitter_account
    @pawn.twitter_account.username.should == @pawn.twitter_username
  end
  describe "execution" do 
    before(:each) do
      @valid_attributes[:active] = true
      @pawn = Pawn.create!(@valid_attributes)
      @valid_attributes[:active] = false      
      @pawn2 = Pawn.create!(@valid_attributes)      
    end
    
    it "should create executions if active" do 
      @pawn.should_receive(:create_executions!)
      Pawn.stub!(:execute!).and_return(@pawn.create_executions!)
      Pawn.execute!
    end
    it "should execute if active" do 
      @pawn.should_receive(:execute!)
      Pawn.stub!(:execute!).and_return(@pawn.execute!)
      Pawn.execute!
    end
    it "should not execute if inactive" do 
      @pawn2.should_not_receive(:execute!)
      Pawn.execute!
    end
    it "should create an execution for a pawn/scheme if there isn't one there" do
      @pawn.stub!(:schemes).and_return([@scheme = mock_model(Scheme, :pawn => @pawn)])
      @scheme.stub!(:executions).and_return([])
      Execution.should_receive(:create)
      @pawn.create_executions!    
    end
    it "should not create an execution for a pawn/scheme if there is one there" do
      @pawn.stub!(:schemes).and_return([@scheme = mock_model(Scheme, :pawn => @pawn)])
      @execution = mock_model(Execution, :pawn => @pawn, :scheme => @scheme)
      @scheme.stub!(:executions).and_return([@execution])
      Execution.should_not_receive(:create)
      @pawn.create_executions!    
    end

  end
end
