class AssignmentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :ensure_grader_or_admin!, :except => [:index, :show]
  
  def index    
    @assignments = Assignment.where(:course_id => params[:course_id])
    @course = Course.find(params[:course_id])
  end
  
  def show
    @assignment = Assignment.find(params[:id])
    @course = Course.find(params[:course_id])
  end
  
  def edit
    if current_user.nil? || !current_user.admin?
      redirect_to course_assignments_path
    else
      @assignment = Assignment.find(params[:id])
      @course = Course.find(params[:course_id])
    end
  end
  
  def update
    @assignment = Assignment.find(params[:id])

    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = "Successfully updated assignment."
      redirect_to course_assignment_path(params[:course_id], @assignment.id)
    else
      render :action => 'edit'
    end
  end
  
  def new    
    @assignment = Assignment.new
    @course = Course.find(params[:course_id])
    
    unless params[:course_id].blank?
      unless Course.exists?(params[:course_id])
        render_404
        return
      end
      @assignment.course_id = params[:course_id]
    end
  end
  
  def create
    @assignment = Assignment.new(params[:assignment])
    @course = Course.find(params[:course_id])
    @assignment.course = @course
    
    if @assignment.save
      flash[:notice] = "Successfully created assignment."
    else
      flash[:notice] = "Unable to create assignment"
    end
    
    redirect_to course_assignments_path(@course)
  end
end
