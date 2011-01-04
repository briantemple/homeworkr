class MakeSubmissionsOwnedByUser < ActiveRecord::Migration
  def self.up
    alter_table :submissions do |t|
      t.references :user, :null => false
    end
  end

  def self.down
    remove_column :submissions, :user 
  end
end
