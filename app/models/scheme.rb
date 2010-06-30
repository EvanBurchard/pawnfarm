class Scheme < ActiveRecord::Base
  belongs_to :pawn
  validates_presence_of :pawn_id
  validates_presence_of :type  
end
