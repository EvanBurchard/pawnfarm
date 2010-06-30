class Scheme < ActiveRecord::Base
  belongs_to :scheme_type
  belongs_to :pawn
end
