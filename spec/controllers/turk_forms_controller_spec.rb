require 'spec_helper'

describe TurkFormsController do
  
  describe "GET 'show'" do
    before(:each) do 
      TurkForm.stub!(:find).and_return(@turk_form = mock_model(TurkForm, :id => 1, :body => "some text"))
      get 'show', :id => 1
    end
    
    it "should be successful" do  
      response.should be_success
    end
    it "should assign to scheme" do
      assigns(:turk_form).should_not be_nil
    end
  end
end
