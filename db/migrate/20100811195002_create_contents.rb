class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.references :submission
      t.references :requirement
      t.integer :type
      t.string :notes
      
      # Paperclip attachment parameters
      t.string  :attachment_file_name
      t.string  :attachment_content_type
      t.integer :attachment_file_size
      
      t.timestamps
    end
  end

  def self.down
    drop_table :contents
  end
end
