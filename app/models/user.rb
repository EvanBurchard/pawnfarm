class User < ActiveRecord::Base
  acts_as_authentic 
  has_many :pawns
  def self.find_by_login_or_email(login)
    User.find_by_login(login) || User.find_by_email(login)
  end
  
end
