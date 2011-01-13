class SubmissionExecutionJob < Struct.new(:id)

  def perform
    submission = Submission.find(id)
    
    execution_directory = "#{RAILS_ROOT}/public/system/execution/#{id}"
    
    # Create execution folder
    FileUtils.mkdir_p(execution_directory)

    # Stage uploaded files
    submission.contents.each do |content|
      unless content.attachment.path.nil?
        FileUtils.copy(content.attachment.path, File.join(execution_directory, content.requirement.name) )
      end
    end
    
    # Stage assets and execution commands (set +x for compile and execution files)
    submission.assignment.assets.each do |asset|
      unless asset.attachment.path.nil?
        path = File.join(execution_directory, asset.name)
        FileUtils.copy(asset.attachment.path, path)
        
        if asset.script == 2 || asset.script == 3
          FileUtils.chmod 0700, path
        end
      end
    end

    # Compile
    compilation_success = true
    compilation_output_location = File.join(execution_directory, "compilation.out")
    submission.assignment.assets.each do |asset|
      if asset.script == 2
        unless sandbox_exec("./#{asset.name} 1>> #{compilation_output_location} 2>&1", execution_directory)
          compilation_success = false
        end
      end
    end
    
    # Store output in database
    if File::exists? compilation_output_location
      submission.compilation_output = File.read(compilation_output_location)
    end

    # Execute
    execution_output_location = File.join(execution_directory, "execution.out")
    if compilation_success
      submission.assignment.assets.each do |asset|
        if asset.script == 3
          # Run
          sandbox_exec("./#{asset.name} 1>> #{execution_output_location} 2>&1", execution_directory)          
        end
      end
    end
    
    # Store output in database
    if File::exists? execution_output_location
      submission.execution_output = File.read(execution_output_location)
    end
    
    # Save self 
    submission.save
  end
  
  private
  def sandbox_exec(command, execution_directory)
    sandbox_template_path = "#{RAILS_ROOT}/config/execution.sb"
  
    # Stage security file
    sandbox_config = File.read(sandbox_template_path)
    sandbox_config["EXECUTION_DIRECTORY"]= execution_directory
  
    sandbox_config_location = File.join(execution_directory, 'execution.sb')
    File.open(sandbox_config_location, 'w') {|f| f.write(sandbox_config) }
  
    # Maximum run time is 5 seconds both by cpu and clock time
    return timed_exec("ulimit -t 5;cd #{execution_directory};sandbox-exec -f #{sandbox_config_location} #{command}")
  end
  
  def timed_exec(command)
    rc = false
    begin
      Timeout::timeout(5) { rc = system(command) }
    rescue Timeout::Error
      false
    end
    rc
  end
end