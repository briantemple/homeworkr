class StudentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :ensure_grader_or_admin!

  def index
    @students = User.where(:course_id => params[:course_id], :grader => false, :admin => false)
    @assignments = Assignment.where(:course_id => params[:course_id])
  end
end
