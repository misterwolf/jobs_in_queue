class JobsInQueue

  def initialize(jobs)
    # jobs is a string.
    # The string will be parsed (I suppose) because will contain a sort of json
    # so, either jobs.parse

    @queue = jobs

  end

  def queue
    @queue
  end

end
