class Execution < ActiveRecord::Base
  belongs_to :scheme
  belongs_to :pawn
end
