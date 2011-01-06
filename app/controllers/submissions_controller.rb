class SubmissionsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def index
    # Handle queries
    if !params[:assignment_id].blank?
      if !Assignment.exists?(params[:assignment_id])
        render_404
        return
      end

      if Submission.exists?(:assignment_id => params[:assignment_id], :user_id => current_user)
        submission = Submission.find_for_assignment_id(params[:assignment_id], current_user)
        redirect_to submission
      else
         redirect_to :controller => 'submissions', :action => 'new', :assignment_id => params[:assignment_id]
      end
    else
      @assignments = Assignment.where(:user_id => current_user)
      @submissions = Submission.where(:user_id => current_user)
    end
  end
  
  def show
    @submission = Submission.find(params[:id])
    if @submission.user != current_user && !(current_user.grader == true || current_user.admin == true)
      redirect_to submissions_path
    end
  end
  
  def edit
    @submission = Submission.find(params[:id])
    if @submission.status != 0
      redirect_to @submission
    end
  end
  
  def new
    # Handle queries for objects that do not exist yet  
    assignment = Assignment.find(params[:assignment_id])
    submission = Submission.new
    submission.assignment = assignment
    submission.user = current_user
    submission.save

    assignment.requirements.each do |requirement|
      content = Content.new
      content.submission = submission
      content.requirement = requirement
      content.save
    end
    
    redirect_to submission
  end
  
  def update
    @submission = Submission.find(params[:id])
    previous_status = @submission.status
        
    if @submission.update_attributes(params[:submission])
      if @submission.status == 1 && previous_status == 0
        @submission.submitted_at = Time.now
        @submission.save
      end
      
      flash[:notice] = "Successfully updated submission."
      redirect_to @submission
    else
      render :action => 'edit'
    end
  end
  
end
