require File.dirname(__FILE__) + '/../spec_helper'

describe HomeController, "index without params" do 
  it "should show the home page" do
    get :index
    response.should render_template('index')
  end
end