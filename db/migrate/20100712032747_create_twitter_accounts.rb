class CreateTwitterAccounts < ActiveRecord::Migration
  def self.up
    create_table :twitter_accounts do |t|
      t.string :friends
      t.string :followers
      t.integer :friend_count
      t.integer :follower_count
      t.datetime :last_tweeted
      t.string :status
      t.references :pawn
      t.string :username
      t.string :password
      t.string :access_key
      t.string :access_secret

      t.timestamps
    end
  end

  def self.down
    drop_table :twitter_accounts
  end
end
