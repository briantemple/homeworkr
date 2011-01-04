class AddToAssignment < ActiveRecord::Migration
  def self.up
    add_column :assignments, :description, :string
  end

  def self.down
    remove_column :assignments, :description
  end
end
