class Content < ActiveRecord::Base
  belongs_to :submission
  belongs_to :requirement
  
  has_attached_file :attachment,
                    :url => "/system/attachments/:id/:basename.:extension",  
                    :path => ":rails_root/public/system/attachments/:id/:basename.:extension"

# To get file versioning working: incorporate interpolation changes from                    
# http://eggsonbread.com/2009/07/23/file-versioning-in-ruby-on-rails-with-paperclip-acts_as_versioned/
end
