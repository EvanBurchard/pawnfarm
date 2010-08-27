require File.dirname(__FILE__) + '/../spec_helper'

describe UserSessionsController, "new with a registered user" do
  before(:each) do 
     UserSession.stub!(:new).and_return(@user_session = mock_model(UserSession, :save => true))
  end
  it "should create a new user session object when I get :new" do
    get :new
    assigns[:user_session].should_not be_nil
  end
end

describe UserSessionsController, "create with a registered user" do
  before(:each) do 
     UserSession.stub!(:new).and_return(@user_session = mock_model(UserSession, :save => true))
  end

  def do_create
    post :create, :user_session=> Factory.attributes_for(:user_session)
  end
  
  it "should create the user session" do
    UserSession.should_receive(:new).with({"login" => "registered_user", "password" => "secret"}).and_return(@user_session)
    do_create
  end

  it "should save the user session" do
    @user_session.should_receive(:save).and_return(true)
    do_create
  end
  
  it "should be redirect" do
    do_create
    response.should be_redirect
  end

end

describe UserSessionsController, "create with an unregistered user" do 
  before(:each) do 
     UserSession.stub!(:new).and_return(@user_session = mock_model(UserSession, :save => false))
  end
  
  def do_create
    post :create, :user_session=>Factory.attributes_for(:user_session)
  end
  
  it "should try and fail to save the user session" do 
    @user_session.should_receive(:save).and_return(false)
    do_create
  end
  
  it "should re-render the same form" do
    do_create
    response.should render_template("new")
  end
  
  
  
end
