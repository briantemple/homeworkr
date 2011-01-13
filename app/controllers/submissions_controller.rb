class SubmissionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    # Handle queries
    unless params[:assignment_id].blank?
      handle_assignment_query(params)
      return
    end
    
    unless params[:user_id].blank?
      handle_user_query(params)
      return
    end
    
    @assignments = Assignment.where(:user_id => current_user)
    @submissions = Submission.where(:user_id => current_user)
  end
  
  def handle_assignment_query(params)
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
  end
  
  def handle_user_query(params)
    ensure_grader_or_admin!
    
    @assignments = Assignment.where(:user_id => params[:user_id])
    @submissions = Submission.where(:user_id => params[:user_id])
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
        
        # Execute if compiled assignment
        if @submission.assignment.compiled
          # If needed, move to delayed_job by calling Delayed::Job.enqueue(SubmissionExecutionJob.new(@submission.id))
          SubmissionExecutionJob.new(@submission.id).perform
        end
      end
      
      flash[:notice] = "Successfully updated submission."
      redirect_to @submission
    else
      render :action => 'edit'
    end
  end
  
end
