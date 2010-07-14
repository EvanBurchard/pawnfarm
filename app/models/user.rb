class User < ActiveRecord::Base
  acts_as_authentic 
  has_many :pawns, :dependent => :destroy
  has_many :schemes, :dependent => :destroy
  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email(login)
  end
  
end
