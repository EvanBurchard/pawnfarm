class TurkForm < ActiveRecord::Base
  belongs_to :execution
  
  def prompt
    execution.scheme.prompt
  end
end
