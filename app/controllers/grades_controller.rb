class GradesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_grader_or_admin!
  
  def index
    @course_id = params[:course_id]
    assignment_ids = Assignment.select("id").where(:course_id => @course_id)
    @submissions = Submission.where(:status => 1, :assignment_id => assignment_ids).order("updated_at ASC")
  end
  
  def show    
    @submission = Submission.find(params[:id])
  end
end
