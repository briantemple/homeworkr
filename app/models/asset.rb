class Asset < ActiveRecord::Base
  belongs_to :assignment
  
  has_attached_file :attachment,
                    :url => "/system/assets/:id/:basename.:extension",  
                    :path => ":rails_root/public/system/assets/:id/:basename.:extension"

  # script values can be:
  # 0 => Not a script, just a plain file type like a header
  # 1 => Not a script, but used in compilation or execution
  # 2 => Script to compile code
  # 3 => Script to execute code
  Script_types = [
    ["Plain", 0],
    ["Script asset (not shown to students)", 1],
    ["Compilation script (not shown to students)", 2],
    ["Execution script (not shown to students)", 3]
  ]
  
end