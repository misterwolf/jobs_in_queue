require 'spec_helper'
require_relative '../lib/jobs_in_queue'

# preferring BDD!

describe "JobsInQueue" do

  context 'simple cases before' do

    it 'with no job' do
      jobs_in_queue = JobsInQueue.new('')
      expect(jobs_in_queue.queue).to eq ''
    end

    context 'with more jobs: ' do

      it 'one' do
        jobs_in_queue = JobsInQueue.new('a =>')
        expect(jobs_in_queue.queue).to eq 'a'
      end

      it 'two' do
        skip
      end

      it 'three' do
        skip

      end

    end

  end

  context 'then, error or exception cases' do

    context 'with a not well-formed job' do

      it 'wrong symbol for dependency' do
        skip
      end

      it 'wrong symbol for dependent job' do
        skip
      end

      it 'wrong symbol for prior job' do
        skip
      end

    end

    it 'dead lock dependency (when a job depends from itself)' do
      skip
    end

    it 'circular dependencies' do
      # wow!
      # let's see after
      skip
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
