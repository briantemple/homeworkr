class AssignmentsController < ApplicationController
  def index
    @assignments = Assignment.all
  end
  
  def show
    @assignment = Assignment.find(params[:id])
  end
  
  def edit
    if current_user.nil? || !current_user.admin?
      redirect_to assignments_path
    else
      @assignment = Assignment.find(params[:id])
    end
  end
  
  def update
    @assignment = Assignment.find(params[:id])

    if @assignment.update_attributes(params[:assignment])
      flash[:notice] = "Successfully updated assignment."
      redirect_to @assignment
    else
      render :action => 'edit'
    end
  end
  
  def new
    @assignment = Assignment.new
  end
  
  def create
    @assignment = Assignment.new(params[:assignment])
    if @assignment.save
      flash[:notice] = "Successfully created assignment."
    else
      flash[:notice] = "Unable to create assignment"
    end
    
    redirect_to assignments_path
  end
end
