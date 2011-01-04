class CreateAssignments < ActiveRecord::Migration
  def self.up
    create_table :assignments do |t|
      t.string :name
      t.datetime :due
      t.string :abstract
      
      t.timestamps
    end
  end

  def self.down
    drop_table :assignments
  end
end
