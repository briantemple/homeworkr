class CreateRequirements < ActiveRecord::Migration
  def self.up
    create_table :requirements do |t|
      t.references :assignment
      t.string :name
      
      t.timestamps
    end
  end

  def self.down
    drop_table :requirements
  end
end
