class AddTypeToTurkForm < ActiveRecord::Migration
  def self.up
    add_column :turk_forms, :form_type, :string
  end

  def self.down
    remove_column :turk_forms, :form_type
  end
end
