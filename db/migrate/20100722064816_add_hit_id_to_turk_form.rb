class AddHitIdToTurkForm < ActiveRecord::Migration
  def self.up
    add_column :turk_forms, :hit_id, :string    
  end

  def self.down
    remove_column :turk_forms, :hit_id
  end
end
