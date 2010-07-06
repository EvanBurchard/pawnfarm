class CreateTurkForms < ActiveRecord::Migration
  def self.up
    create_table :turk_forms do |t|
      t.string :url
      t.references :execution

      t.timestamps
    end
  end

  def self.down
    drop_table :turk_forms
  end
end
