# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Homeworkr::Application.initialize!

Time::DATE_FORMATS[:assignment] = "%A, %B %d, %Y"
Time.zone = 'Mountain Time (US & Canada)'
