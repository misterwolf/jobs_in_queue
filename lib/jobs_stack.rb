class JobsStack

  def initialize(jobs)
    @queue = []
    @jobs_with_dependency = []
    # jobs is a string.
    # The string will be parsed (I suppose) because will contain a sort of json
    # so, either jobs.parse

    # so, two approaches on parse
    # 1 regular expressions
    # 2 string split(" ") and checking format:
    # => if [ [a-z], "=>" ] ok, other wise not ok.
    # => if [ [a-z], "=>", [a-z] ] ok, other wise not ok.
    # I hate if condition! So regular expressions.

    # god "bless" regular expressions
    # good resource online: https://www.regexpal.com/

    # regular expression for not dependent job
    # ^ => just one not digit letter. Just one is not specified.
    # $ => the string end there 'a =>' => ok, 'a => ' NO ok!

    # -----
    jobs.gsub!('\n',"\n") # I really don't like that user have to put "" instead of '' to specific the \n
    jobs.gsub!(" ",'') # it's more confortable check pair with Regular Expression
    # grouping the jobs by their format
    # (\D) => the first job
    # => is dismessed by the group.
    # (:?\w|) => will match only letters or nothing: ('=>\n' -> '', '=>b' 'b')
    jobs.scan(/(\D)=>(:?\w|)/).each{ |job|
      @queue << job.first
      @jobs_with_dependency << job
    }
    sort_with_no_significant_order
    sort_jobs_with_dependency
  end

  def queue
    @queue
  end

  def sorted_jobs
    @jobs_with_dependency
  end

  private

  # better do not call sort_with_no_significant_order and sort_jobs_with_dependency externally.
  def sort_with_no_significant_order
    @queue.sort! {|a,b| a<=>b }
  end

  def sort_jobs_with_dependency
    sorted_stack = []
    @jobs_with_dependency.each { |job, related_job|
      # this is my idea:
      # check for one free job and add it on stack starting from the position.
      # then, if related exists, search it in the next_jobs
      # depend_job => related_job
      # this will work only with one dependency
      if related_job == ''
        sorted_stack << job
      else
        sorted_stack << related_job << job
      end

    }

    @jobs_with_dependency = sorted_stack.uniq
      # a => c
      # b => a
      # c => a
      # this is wrong.

      # a => b
      # b => c
      # c => f
      # d =>
      # f => d
      # the correct sequence is:
      # d f c b a       

      # 1 all the jobs free from dependencies can go first.
      # 2 all the dependent jobs can go back
      # 3 all the jobs related to a dependency can go in the middle 
      # d first
      # we can liberate the job related to "d"
      # f
      # now we can liberate job c that's the job related to f
      # c
      # now we can liberate job b that's the job related to c
      # b
      # now we can liberate job a that's the job related to c
      # a
      # the correct sequence is:
      # d f c b a

      # a => b
      # b => c
      # c => f
      # d => a
      # f => c
      # this is wrong:
      #   so when all the existing job have a dependency there is something of bad.
      # 

      # a => b
      # b => a
      # c => f
      # d =>
      # f => c
      # this is wrong:
      #   there is a dead lock a job depends from a job that depend from the first
      # 

      # this is the example proposed from test:
      # a =>
      # b => c
      # c => f
      # d => a
      # e => b
      # f =>
      #
      # a first
      # we can liberate the job d related to a
      # d
      # job d has not children, going to run the next free job
      # there is a free job? no => (error), yes f
      # f
      # now we can liberate job c that's the job related to f
      # c
      # now we can liberate job b that's the job related to c
      # b
      # now we can liberate job e that's the job related to b
      # e

  end

end
