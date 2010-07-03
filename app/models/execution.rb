class Execution < ActiveRecord::Base
  belongs_to :scheme
  belongs_to :pawn
  
  include AASM
  
end
