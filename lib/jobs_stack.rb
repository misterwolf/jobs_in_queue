class JobsStack

  def initialize(jobs)
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
    @queue = []
    jobs = jobs.gsub('\n',"\n") # I really don't like that user have to put "" instead of '' to specific the \n

    # grouping the jobs by their format
    # (\D) => the first job
    # => is dismessed by the group.
    # (:?\D|) => something different from number (a \n or a letter) or nothing: ('=>\n', '=>' or '=>b')
    jobs.scan(/(\D) =>(:?\D|)/).each{ |job|
      @queue << job.first
    }
  end

  def queue
    @queue.sort {|a,b| a<=>b} # sort alphabetically
  end

end
