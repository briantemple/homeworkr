class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :requirements
  has_many :assets
  
  accepts_nested_attributes_for :requirements, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :assets, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
end
