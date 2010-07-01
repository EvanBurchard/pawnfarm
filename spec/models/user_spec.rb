require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it { should have_many(:pawns) }
  it { should have_many(:schemes) }
  
  it { should have_db_column(:login).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:email).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:crypted_password).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:password_salt).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:persistence_token).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:single_access_token).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:perishable_token).of_type(:string).with_options(:null => false) }
  it { should have_db_column(:login_count).of_type(:integer).with_options(:default => 0, :null => false) }
  it { should have_db_column(:failed_login_count).of_type(:integer).with_options(:default => 0, :null => false) }
  it { should have_db_column(:last_request_at).of_type(:datetime)}
  it { should have_db_column(:current_login_at).of_type(:datetime)}
  it { should have_db_column(:last_login_at).of_type(:datetime)}
  it { should have_db_column(:current_login_ip).of_type(:string)}
  it { should have_db_column(:created_at).of_type(:datetime)}
  it { should have_db_column(:updated_at).of_type(:datetime)}
    
  before :each do
    @user = Factory.create(:user)
  end 
  describe :find_by_login_or_email do
    it "should find a user given a registered email" do
      User.find_by_login_or_email(@user.email).should == @user
    end
    
    it "should find a user given a registered login" do
      User.find_by_login_or_email(@user.login).should == @user
    end
    
    it "should not find a user given an unregistered login" do 
      User.find_by_login_or_email('thisisbullshit').should be_nil
    end
  end
  
end
