class JobsInQueue

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
    # jobs =~ /^\D =>$/ => this work.

    # simple, but something of particoular is coming
    @queue = if jobs == ''
      jobs
    else
      jobs.gsub(' =>', '')
    end

  end

  def queue
    @queue
  end

end
