require 'spec_helper'

describe Execution do
  it { should have_many(:turk_forms).dependent(:destroy)}
  it { should belong_to(:scheme) }
  it { should belong_to(:pawn) }
  
  it { should validate_presence_of(:scheme_id) }
  it { should validate_presence_of(:pawn_id) }

  it { should have_db_column(:tweeted_at).of_type(:datetime) }
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
      :pawn => (@pawn = mock_model(Pawn, :id => 1)),
      :candidate_a => "value for candidate_a",
      :candidate_b => "value for candidate_b",
      :winner => "value for winner"
    }
    @scheme.stub!(:get_status_for_tweet_prompt).and_return("status message")
    @scheme.stub!(:create_executions!)
  end

  it "should create a new instance given valid attributes" do
    @execution = Execution.new(@valid_attributes)
    @execution.stub!(:create_hit).and_return(@hit = mock_model(RTurk::Hit))
    @hit.stub!(:url).and_return("http://fake_form_url.com")
    @execution.stub!(:find_write_form).and_return(@turk_form = mock_model(TurkForm, :form_type => "write", :execution_id => @execution.id))
    @turk_form.stub!(:update_attribute)
    @execution.save
  end
  
  describe "for the exection of a RtScheme" do
    before(:each) do 
      @valid_attributes[:scheme] = @scheme = mock_model(Scheme, :id => 1, :type => "RtScheme", :tweet_prompt => "a_user")
      @valid_attributes[:state] = "retweeting"
      @execution = Execution.new(@valid_attributes)      
      @pawn.stub!(:retweet)
      @execution.scheme.stub!(:frequency).and_return(1)      
      @execution.scheme.stub!(:target_account).and_return("account")
    end
    it "should retweet" do 
      @pawn.should_receive(:retweet)
      @execution.save
    end
    it "should not run the build forms method" do
      @execution.should_not_receive(:build_forms)    
      @execution.save
    end
    it "should run the tweet method" do
      @execution.should_receive(:tweet)    
      @execution.save
    end
    it "should build not a turk form" do
      @execution.save
      @execution.turk_forms[0].should be nil    
    end
    it "should not run the form body text method" do
      @execution.should_not_receive(:form_body_text)
      @execution.save
    end
    it "tweeted state" do
      @execution.save
      @execution.state.should == "tweeted"    
    end

    it "should check if there's been a recent tweet by the same execution type" do 
      @execution.should_receive(:time_to_tweet?)
      @execution.save
    end
    it "should call when to tweet" do 
      @execution.should_receive(:when_to_tweet).and_return(Time.now)
      @execution.save
    end  
    it "should set the tweeted_at to Time.now" do
      Timecop.freeze(Date.today) do
        @execution.save
        @execution.tweeted_at.should == Time.now
      end
    end
    it "should not call turk for candidates" do
      @execution.should_not_receive(:turk_for_candidates)
      @execution.save      
    end
    describe "if there's been a recent tweet by the same execution type" do 
      Timecop.freeze(Date.today) do
        before(:each) do
          @valid_attributes = {
            :scheme => (@scheme = mock_model(Scheme, :id => 1, :tweet_prompt => nil, :prompt => nil)),
            :pawn => (@pawn = mock_model(Pawn, :id => 1)),
            :candidate_a => "value for candidate_a",
            :candidate_b => "value for candidate_b",
            :winner => "value for winner"
          }
          @execution.scheme.stub!(:target_account).and_return("account")
          @execution.scheme.stub!(:frequency).and_return(1)      
        end
        it "should call time to tweet" do 
          @execution.should_receive(:time_to_tweet?)
          @execution.save
        end  
        it "should call when to tweet" do 
          @execution.should_receive(:when_to_tweet).and_return(Time.now + 3.hours)
          @execution.save
        end  
        it "should not set the tweeted_at to Time.now" do
          @execution.stub!(:time_to_tweet?).and_return(false)
          @execution.save
          @execution.tweeted_at.should be nil
        end
        
        it "should have a retweeting state" do
          @execution.stub!(:time_to_tweet?).and_return(false)
          @execution.save
          @execution.state.should == "retweeting"    
        end
        it "should not call turk for candidates" do
          @execution.should_not_receive(:turk_for_candidates)
          @execution.save      
        end
        
      end
    end    
    
  end
  
  describe "for the building form phase" do 
    describe "for an execution of an @ scheme" do
      describe "with a tweet_prompt" do 
        before(:each) do 
          @valid_attributes[:scheme] = @scheme = mock_model(Scheme, :id => 1, :type => "AtScheme", :tweet_prompt => "a user", :prompt => nil)
          @scheme.stub!(:get_status_for_tweet_prompt).and_return("status message")
          @execution = Execution.new(@valid_attributes)      
          @execution.stub!(:create_hit).and_return(@hit = mock_model(RTurk::Hit))
          @hit.stub!(:url).and_return("http://fake_form_url.com")
          @execution.scheme.stub!(:create_executions!)
          @execution.stub!(:find_write_form).and_return(@turk_form = mock_model(TurkForm, :form_type => "write", :execution_id => @execution.id))
          @turk_form.stub!(:update_attribute)
        end
        
        it "should run the build_forms method" do
          @execution.should_receive(:build_forms)
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
        it "should receive get status for target account" do
          @scheme.should_receive(:get_status_for_tweet_prompt)
          @execution.save
        end
        it "should call create_executions!" do
          @execution.scheme.should_receive(:create_executions!)
          @execution.save    
        end
        it "should call turk for candidates" do
          @execution.should_receive(:turk_for_candidates)
          @execution.save      
        end
        it "should find the write form" do
          @execution.should_receive(:find_write_form)
          @execution.save      
        end
      end
      describe "without a tweet_prompt" do 
        before(:each) do 
          @valid_attributes[:scheme] = @scheme = mock_model(Scheme, :id => 1, :type => "AtScheme", :tweet_prompt => nil, :prompt => nil)
          @execution = Execution.new(@valid_attributes)      
          @execution.scheme.stub!(:create_executions!)
          @execution.stub!(:create_hit).and_return(@hit = mock_model(RTurk::Hit))
          @hit.stub!(:url).and_return("http://fake_form_url.com")
          @execution.stub!(:find_write_form).and_return(@turk_form = mock_model(TurkForm, :form_type => "write", :execution_id => @execution.id))
          @turk_form.stub!(:update_attribute)
        end
  
        it "should run the build_forms method" do
          @execution.should_receive(:build_forms)
          @execution.save
        end
        it "should build a turk form" do
          @execution.save
          @execution.turk_forms[0].should_not be nil    
        end
        it "should have some text in the body of the turk form" do
          @execution.save
          @execution.turk_forms[0].body.should be nil    
        end
        it "should run the form body text method" do
          @execution.should_receive(:form_body_text)
          @execution.save
        end
        it "should have the seeking candidates state" do
          @execution.save
          @execution.state.should == "seeking_candidates"    
        end
        it "should not receive get status for target account" do
          @scheme.should_not_receive(:get_status_for_tweet_prompt)
          @execution.save
        end
  
        it "should call turk_for_candidates" do
          @execution.should_receive(:turk_for_candidates)
          @execution.save    
        end
        it "should call create_executions!" do
          @execution.scheme.should_receive(:create_executions!)
          @execution.save    
        end
      end
    end
  end

  describe "when candidates are found" do
    before(:each) do
      @execution = Execution.new(@valid_attributes)
      @execution.scheme.stub!(:create_executions!)
      @execution.stub!(:find_write_form).and_return(@turk_form = mock_model(TurkForm, :form_type => "write", :execution_id => @execution.id))
      @execution.stub!(:create_hit).and_return(@hit = mock_model(RTurk::Hit))
      @hit.stub!(:url).and_return("http://fake_form_url.com")
      @turk_form.stub!(:update_attribute)
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
      @execution.scheme.stub!(:create_executions!)
      @execution.stub!(:find_write_form).and_return(@turk_form = mock_model(TurkForm, :form_type => "write", :execution_id => @execution.id))
      @execution.stub!(:create_hit).and_return(@hit = mock_model(RTurk::Hit))
      @hit.stub!(:url).and_return("http://fake_form_url.com")
      @turk_form.stub!(:update_attribute)
      @execution.save    
      @execution.candidate_a = "candidate a"
      @execution.candidate_b = "candidate b"
      @execution.execute! 
      @execution.scheme.stub!(:frequency).and_return(1)      
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
    it "should_receive time_to_tweet?" do
      @execution.stub!(:pawn).and_return(@pawn = mock_model(Pawn, :id => 1))
      @pawn.stub!(:tweet)
      @execution.should_receive(:time_to_tweet?)
      @execution.execute!
    end

    describe "when it is not time to tweet" do
      it "should_have state seeking_review_of_candidates" do
        @execution.stub!(:pawn).and_return(@pawn = mock_model(Pawn, :id => 1))
        @pawn.stub!(:tweet)
        @execution.stub!(:time_to_tweet?).and_return(false)
        @execution.execute!
        @execution.state.should == "seeking_review_of_candidates"
      end      
    end    
  end

end