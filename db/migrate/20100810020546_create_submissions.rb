class CreateSubmissions < ActiveRecord::Migration
  def self.up
    create_table :submissions do |t|
      t.references :assignment
      t.integer :status, :default => 0
      t.string :notes
      t.string :grade
      t.datetime "submitted_at"
      
      t.timestamps
    end
  end

  def self.down
    drop_table :submissions
  end
end
