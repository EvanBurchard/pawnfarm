require 'spec_helper'

describe Execution do
  it { should have_many(:turk_forms)}
  it { should belong_to(:scheme) }
  it { should belong_to(:pawn) }
  
  it { should validate_presence_of(:scheme) }
  it { should validate_presence_of(:pawn) }
  
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
      :scheme => (@scheme = mock_model(Scheme, :id => 1, :tweet_prompt => nil, :prompt => nil)),
      :pawn => mock_model(Pawn, :id => 1),
      :candidate_a => "value for candidate_a",
      :candidate_b => "value for candidate_b",
      :winner => "value for winner"
    }
    @scheme.stub!(:get_status_for_tweet_prompt).and_return("status message")
  end

  it "should create a new instance given valid attributes" do
    Execution.create!(@valid_attributes)
  end
  
  describe "for the building form phase" do 
    describe "for an execution of an @ scheme" do
      describe "with a tweet_prompt" do 
        before(:each) do 
          @valid_attributes[:scheme] = @scheme = mock_model(Scheme, :id => 1, :type => "AtScheme", :tweet_prompt => "a user", :prompt => nil)
          @scheme.stub!(:get_status_for_tweet_prompt).and_return("status message")
          @execution = Execution.new(@valid_attributes)      
        end

        it "should run the build_form method" do
          @execution.should_receive(:build_form)
          @execution.save
        end
        it "should build a turk form" do
          @execution.save
          @execution.turk_forms[0].should_not be nil    
        end
        it "should have some text in the body of the turk form" do
          @execution.save
          @execution.turk_forms[0].body.should_not be nil    
        end
        it "should run the form body text method" do
          @execution.should_receive(:form_body_text)
          @execution.save
        end
        it "should have the seeking candidates state" do
          @execution.save
          @execution.state.should == "seeking_candidates"    
        end
        it "should receive get status for target" do
          @scheme.should_receive(:get_status_for_tweet_prompt)
          @execution.save
        end

        it "should call turk_for_candidates" do
          @execution = Execution.new(@valid_attributes)
          @execution.should_receive(:turk_for_candidates)
          @execution.save    
        end
      end
      describe "without a tweet_prompt" do 
        before(:each) do 
          @valid_attributes[:scheme] = @scheme = mock_model(Scheme, :id => 1, :type => "AtScheme", :tweet_prompt => nil, :prompt => nil)
          @execution = Execution.new(@valid_attributes)      
        end

        it "should run the build_form method" do
          @execution.should_receive(:build_form)
          @execution.save
        end
        it "should build a turk form" do
          @execution.save
          @execution.turk_forms[0].should_not be nil    
        end
        it "should have some text in the body of the turk form" do
          @execution.save
          @execution.turk_forms[0].body.should_not be nil    
        end
        it "should run the form body text method" do
          @execution.should_receive(:form_body_text)
          @execution.save
        end
        it "should have the seeking candidates state" do
          @execution.save
          @execution.state.should == "seeking_candidates"    
        end
        it "should not receive get status for target" do
          @scheme.should_not_receive(:get_status_for_tweet_prompt)
          @execution.save
        end

        it "should call turk_for_candidates" do
          @execution = Execution.new(@valid_attributes)
          @execution.should_receive(:turk_for_candidates)
          @execution.save    
        end
      end
    end
  end

  describe "when candidates are found" do
    before(:each) do
      @execution = Execution.new(@valid_attributes)
      @execution.save    
      @execution.candidate_a = "candidate a"
      @execution.candidate_b = "candidate b"
    end
    
    it "should check for the candidates" do
      @execution.should_receive(:candidates_found?)
      @execution.execute! 
    end
    it "should call found_candidates when candidate_1 and candidate_2 are defined" do
      @execution.should_receive(:found_candidates)
      @execution.execute! 
    end
    it "should have 2 forms defined" do
      @execution.execute! 
      @execution.turk_forms[0].should_not be nil    
      @execution.turk_forms[1].should_not be nil    
    end
    it "should change the state to candidates_found" do
      @execution.execute! 
      @execution.state.should == "seeking_review_of_candidates"
    end
    it "should build the review form (for the second turk task)" do
      @execution.should_receive(:build_review_form)
      @execution.execute! 
    end
    it "should seek candidates" do
      @execution.should_receive(:turk_for_review)
      @execution.execute! 
    end
    
  end
  describe "when a winner is selected" do
    before(:each) do
      @execution = Execution.new(@valid_attributes)
      @execution.save    
      @execution.candidate_a = "candidate a"
      @execution.candidate_b = "candidate b"
      @execution.execute! 
    end
    it "should call winner_found?" do
      @execution.should_receive(:winner_found?)
      @execution.execute!       
    end
    it "should call found_winner" do
      @execution.should_receive(:found_winner)
      @execution.execute!       
    end
    it "should set winner to one of the candidates" do
      @execution.stub!(:pawn).and_return(@pawn = mock_model(Pawn, :id => 1))
      @pawn.stub!(:tweet)
      @execution.execute!       
      [@execution.candidate_a, @execution.candidate_b].should include(@execution.winner)
    end
    it "should call tweet_winner" do
      @execution.should_receive(:tweet_winner)
      @execution.execute!       
    end
    it "should call @pawn.tweet" do
      @execution.stub!(:pawn).and_return(@pawn = mock_model(Pawn, :id => 1))
      @pawn.should_receive(:tweet)
      @execution.execute!       
    end
    it "should call tweet_it" do
      @execution.stub!(:pawn).and_return(@pawn = mock_model(Pawn, :id => 1))
      @pawn.stub!(:tweet)
      @execution.should_receive(:tweet)       
      @execution.execute!
    end
    it "should have state 'tweeted' " do
      @execution.stub!(:pawn).and_return(@pawn = mock_model(Pawn, :id => 1))
      @pawn.stub!(:tweet)
      @execution.execute!
      @execution.state.should == "tweeted"           
    end
    
  end

end
