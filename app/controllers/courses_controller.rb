class CoursesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  before_filter :ensure_admin!, :except => [:index, :show]
  
  def index
   @courses = Course.all
  end
  
  def show
    @course = Course.find(params[:id])
  end
  
  def edit
    if current_user.nil? || !current_user.admin?
      redirect_to courses_path
    else
      @course = Course.find(params[:id])
    end
  end
  
  def update
    @course = Course.find(params[:id])

    if @course.update_attributes(params[:course])
      flash[:notice] = "Successfully updated course."
      redirect_to @course
    else
      render :action => 'edit'
    end
  end
  
  def new
    @course = Course.new
  end
  
  def create
    @course = Course.new(params[:course])
    if @course.save
      flash[:notice] = "Successfully created course."
    else
      flash[:notice] = "Unable to create course."
    end
    
    redirect_to courses_path
  end
end
