class Course < ActiveRecord::Base
  has_many :assignments
  has_many :users
end
