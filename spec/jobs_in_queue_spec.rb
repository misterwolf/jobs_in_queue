require 'spec_helper'
require_relative '../lib/jobs_in_queue'

# preferring BDD!

describe "JobsInQueue" do

  context 'simple cases before' do

    it 'with no job' do
      jobs_in_queue = JobsInQueue.new('')
      expect(jobs_in_queue.queue).to eq ''
    end

    it 'with one job' do
      # it starts to be more serious 
    end

    it 'with two jobs' do

    end

    it 'with three jobs' do

    end

  end

  context 'then, error or exception cases' do

    context 'dead lock dependency (when a job depends from itself)' do

    end
    context 'circular dependencies' do
      # wow!
      # let's see after
    end

  end

  context 'then, complex cases' do

    context 'with one dependency' do

    end
    context 'with two dependencies' do

    end
    context 'with a lot of dependencies' do

    end

  end

end
