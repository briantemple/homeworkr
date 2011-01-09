class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :name
      t.text :homepage
      
      t.timestamps
    end
    
    change_table :assignments do |t|
      t.references :course
    end
    
    change_table :users do |t|
      t.references :course
    end
  end

  def self.down
    change_table :assignments do |t|
      t.remove_references :course
    end
    
    change_table :users do |t|
      t.remove_references :course
    end
    
    drop_table :courses
  end
end
