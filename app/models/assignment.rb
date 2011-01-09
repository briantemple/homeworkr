class Assignment < ActiveRecord::Base
  belongs_to :course
  has_many :requirements
  accepts_nested_attributes_for :requirements, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
end
