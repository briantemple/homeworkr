class GradesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    unless current_user.grader? || current_user.admin?
      render_401
    end
    
    @submissions = Submission.where(:status => 1).order("updated_at ASC")
  end
  
  def show
    unless current_user.grader? || current_user.admin?
       render_401
    end
    
    @submission = Submission.find(params[:id])
  end
end
