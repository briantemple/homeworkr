class Submission < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :user
  has_many :contents
  accepts_nested_attributes_for :contents
  
  def self.find_for_assignment_id(assignment_id, user)
    sql = %q{
      select * from submissions where assignment_id = ? and user_id = ?
    }
    found = find_by_sql [sql, assignment_id, user.id]
  end

  def days_late
    return "" if self.submitted_at.nil?
    
    days_late = (self.submitted_at - self.assignment.due)/60/60/24

    return "On time" if days_late < 0

    days_late = days_late.ceil.to_i
    days_late.to_s
  end
  
  def grade_modifier
    return "" if self.submitted_at.nil?
    
    days_late = (self.submitted_at - self.assignment.due)/60/60/24

    return "" if days_late < 0

    days_late = days_late.ceil.to_i
    "-#{days_late.to_s}"
  end
end
