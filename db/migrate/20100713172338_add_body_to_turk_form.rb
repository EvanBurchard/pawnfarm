class AddBodyToTurkForm < ActiveRecord::Migration
  def self.up
    add_column :turk_forms, :body, :text
  end

  def self.down
    remove_column :turk_forms, :body
  end
end
