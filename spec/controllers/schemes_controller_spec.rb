require 'spec_helper'

describe SchemesController do
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
        Scheme.stub!(:find).and_return(@scheme = mock_model(Scheme, :id => 1))
        @scheme.stub!(:update_attributes).and_return(true)
        @scheme.stub!(:user).and_return(mock_model(User, :id=>2))      
        get action, :id => 1
        # flash[:error].should_not be_nil
        response.should redirect_to(scheme_path(@scheme))
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
        Scheme.stub!(:new).and_return(@scheme = mock_model(Scheme))
        get :new
      end
      it "should assign to scheme" do 
        assigns[:scheme].should_not be_nil
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
        Scheme.stub!(:find).and_return(@scheme = mock_model(Scheme, :id => 1, :user_id => @current_user.id))
        @scheme.stub!(:user).and_return(@current_user)      
        get 'edit', :id => 1
      end

      it "should be successful" do
        response.should be_success
      end 

      it "should assign to scheme" do
        assigns[:scheme].should_not be_nil
      end
    end
  end

  describe "Without logging in" do
    describe "when I GET 'new'" do
      before(:each) do 
        controller.stub!(:current_user).and_return(nil)
        Scheme.stub!(:new).and_return(@scheme = mock_model(Scheme))
        get :new
      end
      it "should not call assign to scheme" do 
        assigns[:scheme].should be_nil
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
        Scheme.stub!(:find).and_return(@scheme = mock_model(Scheme, :id => 1))
        controller.stub!(:current_user).and_return(nil)
        get 'edit', :id => 1
      end

      it "should be redirect" do
        response.should be_redirect
      end 

      it "should not assign to scheme" do
        assigns[:scheme].should be_nil
      end
    end
  end

  
  describe "when I GET 'show'" do
    it "should be successful" do
      Scheme.stub!(:find).and_return(@scheme = mock_model(Scheme, :id => 1))
      @scheme.stub!(:user).and_return(@user = mock_model(User, :id => 1))
      get 'show', :id => 1
      response.should be_success
    end
  end
  
  describe "when I successfully POST 'create" do 
    
    before(:each) do
      Scheme.stub!(:new).and_return(@scheme = mock_model(Scheme, :save=>true))      
      @scheme.stub!(:user_id=).and_return(true)      
      controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
    end

    def do_create
      post :create, :scheme =>{:title=>"scheme", :description => "this is a scheme"}
    end
    
    it "should create the scheme" do
      Scheme.should_receive(:new).with("title"=>"scheme", "description" => "this is a scheme").and_return(@scheme)
      do_create
    end
    
    it "should assign the scheme" do
      do_create
      assigns(:scheme).should_not be_nil
    end
    
    it "should save the scheme" do
      @scheme.should_receive(:save).and_return(true)
      do_create
    end

    it "should be redirect" do
      do_create
      response.should be_redirect
    end
  end

  describe "when I unsuccessfully POST 'create" do 
    
    before(:each) do
      Scheme.stub!(:new).and_return(@scheme = mock_model(Scheme, :save=>false))
      @scheme.stub!(:user_id=).and_return(true)      
      controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
    end

    def do_create
      post :create, :scheme =>{:title=>"scheme", :description => "this is a scheme"}
    end
    
    it "should create the scheme" do
      Scheme.should_receive(:new).with("title"=>"scheme", "description" => "this is a scheme").and_return(@scheme)
      do_create
    end
    
    it "should assign the scheme" do
      do_create
      assigns(:scheme).should_not be_nil
    end
    
    it "should save the scheme" do
      @scheme.should_receive(:save).and_return(false)
      do_create
    end

    it "should rerender form" do
      do_create
      response.should render_template("new")
    end                   

  end

  describe "when I delete a scheme" do 
    def do_delete
      delete :destroy, :id => @scheme.id, :scheme => @scheme
    end

    before(:each) do
      controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
      Scheme.stub!(:find).and_return(@scheme = mock_model(Scheme, :id=> 1, :user_id => 1))
      @scheme.stub!(:user).and_return(@current_user)      
      Scheme.stub!(:delete).and_return(true) 
    end

    it "should assign to scheme" do
      do_delete
      assigns[:scheme].should_not be_nil
    end
    
    it "should delete the scheme" do
      Scheme.should_receive(:delete).and_return(true)
      do_delete
    end
    
    it "should be redirect" do
      do_delete
      response.should be_redirect
    end
    it "should redirect to the schemes page" do 
      do_delete
      response.should redirect_to(schemes_url)                   
    end
  end
    
  describe "when I PUT update" do
    before(:each) do 
      controller.stub!(:current_user).and_return(@current_user = mock_model(User, :id=>1))
      Scheme.stub!(:find).and_return(@scheme = mock_model(Scheme, :user_id => 1))
      @scheme.stub!(:user).and_return(@current_user)      
      @scheme.stub!(:update_attributes).and_return(true)
    end
    def do_update
      put 'update', :id => @scheme.id, :scheme => {:title=>"scheme", :description =>"scheme"}
    end
    it "should call find" do
      Scheme.should_receive(:find).and_return(@scheme)
      do_update
    end

    it "should update the scheme object's attributes" do
      @scheme.should_receive(:update_attributes).and_return(true)
      do_update
    end

    it "should assign to scheme" do 
      do_update
      assigns[:scheme].should_not be_nil
    end

    it "should be redirect" do
      do_update
      response.should be_redirect    
    end

    it "should redirect to the scheme path" do
      do_update
      response.should redirect_to(scheme_path(@scheme))
    end
    
  end
end
