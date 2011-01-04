class GradesController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    if !(current_user.grader == true || current_user.admin == true)
       redirect_to :controller => 'submissions', :action => 'index'
    end
    
    if Submission.exists?(:status => 1)
      @submissions = Submission.where(:status => 1).order("updated_at ASC")
    end
  end
  
  def show
    unless current_user.grader? || current_user.admin?
       redirect_to :controller => 'submissions', :action => 'index'
    end
    
    if Submission.exists?(params[:id])
      @submission = Submission.find(params[:id])
    else
      redirect_to :controller => 'grades', :action => 'index'
    end
  end
end
