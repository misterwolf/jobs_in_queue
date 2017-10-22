class JobsStack

  class JobsStackError < StandardError
    def initialize(msg=nil)
      @wrong_job = msg
      # others...
    end
  end

  class SelfDependencyError < JobsStackError
    def message
      "this job => #{@wrong_job} depends on itself"
    end
  end

  class CircularDependencyError < JobsStackError
    def message
      "these jobs => #{@wrong_job} depends each other"
    end
  end

  def initialize(jobs)
    @jobs_list  = []
    @jobs   = []
    jobs.gsub!('\n',"\n") # I really don't like that user have to put "" instead of '' to specific the \n
    jobs.gsub!(" ",'')    # It's more confortable check pair with Regular Expression
    jobs.scan(/(\D)=>(:?\w|)/).each { |job|
      @jobs_list << job.first
      @jobs << job
    }
    @jobs = @jobs.to_h # switch to hash
  end

  def sort_jobs_list
    @jobs_list.sort { | a, b | a <=> b }
  end

  # Check for one free job and add it on sorted_stack starting from the last position.
  def sort
    sorted_stack = []
    jobs = @jobs.clone
    while !jobs.empty?
      job, related_job = jobs.first

      # basing on the current job, search the its related free job and add in the sorted stack
      sorted_stack << next_available_job(jobs, sorted_stack, job, related_job)
      jobs.delete(sorted_stack.last) # delete from temp queue last added job
    end
    sorted_stack
  end

  def next_available_job(stack, sorted_jobs, job, related_job, searched = [])
    raise JobsStack::SelfDependencyError,     "#{job}" if job == related_job
    raise JobsStack::CircularDependencyError, "#{job}" + " => "+ "#{stack[job]}" if searched.include?(job)
    if stack[related_job] =~ /\w/
      # if job has a dependency, search long all the related jobs until the first free
      searched << job
      next_available_job(stack, sorted_jobs, related_job, stack[related_job], searched)
    elsif related_job.empty? or sorted_jobs.include?(related_job)
      return job # if related_job is included already in the sorted_jobs, then "job" is free
    else
      return related_job # otherwise it hasn't added in the sorted_jobs job
    end
  end

end
