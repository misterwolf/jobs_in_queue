class JobsStack

  def initialize(jobs)
    @queue = []
    @jobs_with_dependency = []
    @jobs_with_dependency_cloned = []

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
    jobs.scan(/(\D)=>(:?\w|)/).each{ |job|
      @queue << job.first
      @jobs_with_dependency << job
    }
    @jobs_with_dependency_cloned = @jobs_with_dependency.to_h.clone # find a way to create directly an hash!
    sort_with_no_significant_order
    sort_jobs_with_dependency     # keep the original
  end

  def queue
    @queue
  end

  def original_queue
    @jobs_with_dependency
  end

  def sorted_jobs
    @jobs_with_dependency_cloned
  end

  private

  # better do not call sort_with_no_significant_order and sort_jobs_with_dependency externally.
  def sort_with_no_significant_order
    @queue.sort! {|a,b| a<=>b }
  end

  # this is my idea and I need to switch to Hash.
  # Check for one free job and add it on stack starting from the last position.
  # then, if related exists, search it in the next_jobs until it is found, than delete it from stack
  # sort_jobs_with_dependency method
  # => it run a loop where it search for related jobs and job with dependency
  # => whenever one job is found, it is removed from main stack and put in a sorted one.
  def sort_jobs_with_dependency
    stack_with_no_dep, sorted_stack_with_dep = [],[]

    while !@jobs_with_dependency_cloned.empty?
      job, related_job = @jobs_with_dependency_cloned.first
      if related_job == ''
        stack_with_no_dep.unshift(free_job = job) # free a job without dependency
      else
        # if job has dependency search for his related job, until the related*n job with out dependency is found
        # in this way, when a job has more than more than one relate, all of deps will be searched.
        free_job = search_dep(@jobs_with_dependency_cloned, sorted_stack_with_dep + stack_with_no_dep, job, related_job)
        sorted_stack_with_dep.push(free_job) # when found add it to sorted stack
      end
      @jobs_with_dependency_cloned.delete(free_job) # delete the job just added, it won't be parsed anymore.
    end
    @jobs_with_dependency_cloned = sorted_stack_with_dep + stack_with_no_dep

  end

  def search_dep(stack, sorted_jobs, job, related_job)
    if stack[related_job] =~ /\w/
      search_dep(stack, sorted_jobs, related_job, stack[related_job]) # need to further investigate! => related_job has a dependency yet.
    elsif sorted_jobs.include?(related_job)
      return job # if related_job is included already in the sorted_jobs, then "job" can run
    else
      return related_job # otherwise it hasn't added in the sorted_jobs job
    end
  end

end
