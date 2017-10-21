class JobsStack

  def initialize(jobs)
    @queue  = []
    @jobs   = []
    # jobs is a string
    # so, two approaches for "parse" the string
    # 1 regular expressions or
    # 2 string split("=>") and checking format:
    # => if [ [a-z], "=>" ] ok, other wise not ok.
    # => if [ [a-z], "=>", [a-z] ] ok, other wise not ok.
    # I hate if condition! So regular expressions.

    # god "bless" regular expressions
    # good resource online: https://www.regexpal.com/
    # regular expression for not dependent job
    # amazing, I found the Regx grouping:
    # grouping the jobs by their format
    # (\D) => the first job
    # => is dismissed by the group.
    # (:?\w|) => will match only letters or nothing: ('=>\n' -> '', '=>b' 'b')

    jobs.gsub!('\n',"\n") # I really don't like that user have to put "" instead of '' to specific the \n
    jobs.gsub!(" ",'')    # It's more confortable check pair with Regular Expression
    jobs.scan(/(\D)=>(:?\w|)/).each { |job|
      @queue << job.first
      @jobs  << job
    }
    @jobs = @jobs.to_h # switch to hash
  end

  # not required
  # def start_order # not required: to complete the Class for future purpose
  #   unless @sorted # do not repeat sorting if accidentally called
  #     @queue_sorted = sort_with_no_significant_order
  #     @jobs_sorted  = sort
  #     @sorted  = true
  #   end
  # end
  # def jobs_list
  #   @queue
  # end
  # ------

  def sort_jobs_list
    @queue.sort { | a, b | a <=> b }
  end

  # Check for one free job and add it on stack starting from the last position.
  # then, if related exists, search it in the next_jobs until it is found, than add it on new stack
  # => it run a loop where it search for related jobs and job with dependency
  # => whenever one job is found it is put in a sorted one.
  def sort
    sorted_stack = []
    jobs = @jobs.clone
    while !jobs.empty?
      job, related_job = jobs.first
      # if job has dependency search for his related job, until the related*n job with out dependency is found
      # in this way, when a job has more than more than one relate, all of deps will be searched.
      job = search_job_in_deep(jobs, sorted_stack, job, related_job)
      sorted_stack << job # when found add it to sorted stack
      jobs.delete(job)
    end
    sorted_stack
  end

  def search_job_in_deep(stack, sorted_jobs, job, related_job)
    if stack[related_job] =~ /\w/
      search_job_in_deep(stack, sorted_jobs, related_job, stack[related_job]) # need to further investigate! => related_job has a dependency yet.
    elsif related_job.empty? or sorted_jobs.include?(related_job)
      return job # if related_job is included already in the sorted_jobs, then "job" can run
    else
      return related_job # otherwise it hasn't added in the sorted_jobs job
    end
  end

end
