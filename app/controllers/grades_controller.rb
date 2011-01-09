class GradesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_grader_or_admin!
  
  def index    
    @submissions = Submission.where(:status => 1).order("updated_at ASC")
  end
  
  def show    
    @submission = Submission.find(params[:id])
  end
end
