class TwitterAccount < ActiveRecord::Base
  belongs_to :pawn
  validates_presence_of :pawn_id
  validates_presence_of :username
  validates_presence_of :password
  

  
end
