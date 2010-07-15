require 'spec_helper'

describe TurkFormsController do
  
  describe "GET 'show'" do
    before(:each) do 
      TurkForm.stub!(:find).and_return(@turk_form = mock_model(TurkForm, :id => 1, :body => "some text"))
      @turk_form.stub!(:prompt).and_return("some other text")
      get 'show', :id => 1
    end
    
    it "should be successful" do  
      response.should be_success
    end
    it "should assign to turk_form" do
      assigns(:turk_form).should_not be_nil
    end
    it "should assign to prompt" do
      assigns(:prompt).should_not be_nil
    end
  end
end
