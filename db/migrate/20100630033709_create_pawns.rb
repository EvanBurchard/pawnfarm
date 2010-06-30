class CreatePawns < ActiveRecord::Migration
  def self.up
    create_table :pawns do |t|
      t.references :user, :null => false
      t.string :name, :null => false
      t.string :description
      t.string :twitter_username, :null => false
      t.string :twitter_password, :null => false
      
      t.timestamps
    end
  end

  def self.down
    drop_table :pawns
  end
end
