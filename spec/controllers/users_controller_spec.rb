require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do

  describe "when I GET 'show'" do
    def get_show 
      User.stub!(:find).and_return(@user = mock_model(User, :id => 1))    
      get 'show', :id => 1    
    end
    it "should be successful" do
      get_show
      response.should be_success
    end
    it "should assign to @user" do 
      get_show
      assigns[:user].should_not be_nil
    end        
  end
end