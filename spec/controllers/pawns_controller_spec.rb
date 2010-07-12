require 'spec_helper'

describe PawnsController do
    %w[new create edit update destroy].each do |action|
      it "#{action} should redirect to login with error" do
        get action, :id => 1
        # flash[:error].should_not be_nil
        response.should redirect_to(login_path)
      end
    end
    %w[edit update destroy].each do |action|
      it "#{action} should redirect to login with error" do
        controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
        Pawn.stub!(:find).and_return(@pawn = mock_model(Pawn, :id => 1))
        @pawn.stub!(:update_attributes).and_return(true)
        @pawn.stub!(:user).and_return(mock_model(User, :id=>2))      
        get action, :id => 1
        # flash[:error].should_not be_nil
        response.should redirect_to(pawn_path(@pawn))
      end
    end

  
  describe "when I GET 'index'" do 
    before(:each) do 
      get 'index'
    end
    it "should render the index view when I GET 'index'" do
      response.should render_template('index')
    end
  end

  describe "as a logged in user" do
    describe "when I GET 'new'" do
      before(:each) do 
        controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
        Pawn.stub!(:new).and_return(@pawn = mock_model(Pawn))
        get :new
      end
      it "should assign to pawn" do 
        assigns[:pawn].should_not be_nil
      end
      it "should render the new view" do
        response.should render_template('new')
      end
      it "should be successful" do
        response.should be_success
      end
    end
    
    describe "when I GET edit" do 
      before(:each) do
        controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
        Pawn.stub!(:find).and_return(@pawn = mock_model(Pawn, :id => 1, :user_id => @current_user.id))
        @pawn.stub!(:user).and_return(@current_user)      
        get 'edit', :id => 1
      end

      it "should be successful" do
        response.should be_success
      end 

      it "should assign to pawn" do
        assigns[:pawn].should_not be_nil
      end
    end
  end

  describe "Without logging in" do
    describe "when I GET 'new'" do
      before(:each) do 
        controller.stub!(:current_user).and_return(nil)
        Pawn.stub!(:new).and_return(@pawn = mock_model(Pawn))
        get :new
      end
      it "should not call assign to pawn" do 
        assigns[:pawn].should be_nil
      end
      it "should render the new view" do
        response.should_not render_template('new')
      end
      it "should be redirect" do
        response.should be_redirect
      end
    end
    describe "when I GET edit" do 
      before(:each) do
        Pawn.stub!(:find).and_return(@pawn = mock_model(Pawn, :id => 1))
        controller.stub!(:current_user).and_return(nil)
        get 'edit', :id => 1
      end

      it "should be redirect" do
        response.should be_redirect
      end 

      it "should not assign to pawn" do
        assigns[:pawn].should be_nil
      end
    end
  end

  
  describe "when I GET 'show'" do
    it "should be successful" do
      Pawn.stub!(:find).and_return(@pawn = mock_model(Pawn, :id => 1))
      @pawn.stub!(:user).and_return(@user = mock_model(User, :id => 1))
      get 'show', :id => 1
      response.should be_success
    end
  end
  
  describe "when I successfully POST 'create" do 
    
    before(:each) do
      Pawn.stub!(:new).and_return(@pawn = mock_model(Pawn, :save=>true))      
      @pawn.stub!(:user_id=).and_return(true)
      @pawn.stub!(:setup_twitter_account).and_return(@twitter_account = mock_model(TwitterAccount, :id => 1))
      @pawn.stub!(:twitter_account).and_return(@twitter_account)
      @twitter_account.stub!(:authorize_url).and_return("http://api.twitter.com/oauth/authorize?oauth_token=U")
      controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
    end

    def do_create
      post :create, :pawn =>{:name=>"pawn", :description => "this is a pawn"}
    end
    
    it "should create the pawn" do
      Pawn.should_receive(:new).with("name"=>"pawn", "description" => "this is a pawn").and_return(@pawn)
      do_create
    end
    
    it "should assign the pawn" do
      do_create
      assigns(:pawn).should_not be_nil
    end
    
    it "should save the pawn" do
      @pawn.should_receive(:save).and_return(true)
      do_create
    end

    it "should be redirect" do
      do_create
      response.should be_redirect
    end
    it "should redirect to twitter" do
      do_create
      response.should redirect_to("http://api.twitter.com/oauth/authorize?oauth_token=U")
    end
  end

  describe "when I unsuccessfully POST 'create" do 
    
    before(:each) do
      Pawn.stub!(:new).and_return(@pawn = mock_model(Pawn, :save=>false))
      @pawn.stub!(:user_id=).and_return(true)      
      controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
    end

    def do_create
      post :create, :pawn =>{:name=>"pawn", :description => "this is a pawn"}
    end
    
    it "should create the pawn" do
      Pawn.should_receive(:new).with("name"=>"pawn", "description" => "this is a pawn").and_return(@pawn)
      do_create
    end
    
    it "should assign the pawn" do
      do_create
      assigns(:pawn).should_not be_nil
    end
    
    it "should save the pawn" do
      @pawn.should_receive(:save).and_return(false)
      do_create
    end

    it "should rerender form" do
      do_create
      response.should render_template("new")
    end                   

  end

  describe "when I delete a pawn" do 
    def do_delete
      delete :destroy, :id => @pawn.id, :pawn => @pawn
    end

    before(:each) do
      controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
      Pawn.stub!(:find).and_return(@pawn = mock_model(Pawn, :id=> 1, :user_id => 1))
      @pawn.stub!(:user).and_return(@current_user)      
      Pawn.stub!(:delete).and_return(true) 
    end

    it "should assign to pawn" do
      do_delete
      assigns[:pawn].should_not be_nil
    end
    
    it "should delete the pawn" do
      Pawn.should_receive(:delete).and_return(true)
      do_delete
    end
    
    it "should be redirect" do
      do_delete
      response.should be_redirect
    end
    it "should redirect to the pawns page" do 
      do_delete
      response.should redirect_to(pawns_url)                   
    end
  end
    
  describe "when I PUT update" do
    before(:each) do 
      controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
      Pawn.stub!(:find).and_return(@pawn = mock_model(Pawn, :user_id => 1))
      @pawn.stub!(:user).and_return(@current_user)      
      @pawn.stub!(:update_attributes).and_return(true)
    end
    def do_update
      put 'update', :id => @pawn.id, :pawn => {:name=>"pawn", :description =>"pawn"}
    end
    it "should call find" do
      Pawn.should_receive(:find).and_return(@pawn)
      do_update
    end

    it "should update the pawn object's attributes" do
      @pawn.should_receive(:update_attributes).and_return(true)
      do_update
    end

    it "should assign to pawn" do 
      do_update
      assigns[:pawn].should_not be_nil
    end

    it "should be redirect" do
      do_update
      response.should be_redirect    
    end

    it "should redirect to the pawn path" do
      do_update
      response.should redirect_to(pawn_path(@pawn))
    end
    
  end
end

