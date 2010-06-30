class Pawn < ActiveRecord::Base
  belongs_to :user
  has_many :schemes
end
