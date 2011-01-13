class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.references :assignment
      t.string :name
      
      # Is it an asset that is just a plain file (header), a compile script, or an execution script
      t.integer :script, :default => 0
      
      # Paperclip attachment parameters
      t.string  :attachment_file_name
      t.string  :attachment_content_type
      t.integer :attachment_file_size
      
      t.timestamps
    end
    
    change_table :assignments do |t|
      t.boolean :compiled, :default => false
    end
    
    change_table :submissions do |t|
      t.text :compilation
      t.text :execution
    end
  end

  def self.down
    drop_table :assets
    
    remove_column :assignments, :compiled
    remove_column :submissions, :compilation
    remove_column :submissions, :execution
  end
end
