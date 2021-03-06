class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_timezone

  def set_timezone
    Time.zone = 'Mountain Time (US & Canada)'
  end
  
  def ensure_admin!
    if current_user.nil? || !current_user.admin?
      render_401
    end
  end
  
  def ensure_grader_or_admin!    
    if current_user.nil? || !(current_user.grader? || current_user.admin?)
      render_401
    end
  end
  
  def render_404
    render(:file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404)
  end
  
  def render_401
    # Devise intercepts 401 responses until 1.2.rc.  Status should be 401, not 404
    render(:file => "#{RAILS_ROOT}/public/401.html", :layout => false, :status => 404)
  end  
end
