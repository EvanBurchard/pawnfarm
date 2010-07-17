class RenameTargetFieldInScheme < ActiveRecord::Migration
  def self.up
    rename_column :schemes, :target, :target_account
  end

  def self.down
    rename_column :schemes, :target_account, :target
  end
end
