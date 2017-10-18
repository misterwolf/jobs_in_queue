require 'spec_helper'
require_relative '../lib/jobs_in_queue'

# preferring BDD!

describe "JobsInQueue" do

  context 'testing the simple cases before' do

    context 'with no jobs' do

      it 'return an empty sequence' do
        jobs_in_queue = JobsInQueue.new('')
        expect(jobs_in_queue.queue).to eq [] # sequence => [] not ''
      end

    end

    context 'with more jobs ' do

      it 'return a sequence with single job' do
        jobs_in_queue = JobsInQueue.new('a =>')
        expect(jobs_in_queue.queue).to eq ['a =>']
      end

      it 'return a sequence with two jobs' do
        jobs_in_queue = JobsInQueue.new('a =>\nb =>')
        expect(jobs_in_queue.queue).to eq ['a =>','b =>']
      end

      it 'return a sequence with two jobs (with \n escaped)' do
        jobs_in_queue = JobsInQueue.new("a =>\nb =>")
        expect(jobs_in_queue.queue).to eq ['a =>','b =>']
      end

      # three is the perfect number, but not in our case :)

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
