class AddActiveColumnToPawn < ActiveRecord::Migration
  def self.up
    add_column :pawns, :active, :boolean
  end

  def self.down
    remove_column :pawns, :active
  end
end
