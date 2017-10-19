require 'spec_helper'
require_relative '../lib/jobs_stack'

# preferring BDD!

describe "JobsStack" do

  context 'testing the simple cases before' do

    context 'with no jobs' do

      it 'return an empty sequence' do
        jobs_in_queue = JobsStack.new('')
        expect(jobs_in_queue.queue).to eq []
      end

    end

    context 'with more jobs ' do

      it 'return a sequence with single job' do
        jobs_stack = JobsStack.new('a =>')
        expect(jobs_stack.queue).to eq ['a']
      end

      it 'return a sequence with two jobs' do
        jobs_stack = JobsStack.new('a =>\nb =>')
        expect(jobs_stack.queue).to eq ['a','b']
      end

      it 'return a sequence with two jobs (with \n escaped)' do
        jobs_stack = JobsStack.new("a =>\nb =>")
        expect(jobs_stack.queue).to eq ['a','b']
      end

      it 'return a sequence with more unsorted jobs' do
        jobs_stack = JobsStack.new('c =>\na =>\nb =>\n')
        expect(jobs_stack.queue).to eq ['a','b','c']
      end

    end

  end

  context 'then, more complex cases' do

    context 'with one dependency' do
      context 'and with three jobs' do

        let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc =>a\n") }

        it 'have a sequence sorted with a at first position, then c, before b' do
          expect(jobs_stack.sorted_jobs).to eq ['a','c','b']
        end
        it 'have a sequence sorted alphatecally' do
          expect(jobs_stack.queue).to eq ['a','b','c']
        end

      end

      context 'and with four jobs' do
        let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc =>\nd => \n") }

        it 'have this sorted sequence [a,c,b,d]' do
          expect(jobs_stack.sorted_jobs).to eq ['a','c','b','d']
        end
        it 'have this sequence sorted alphatecally: [a,b,c,d]' do
          expect(jobs_stack.queue).to eq ['a','b','c','d']
        end

      end

    end

    context 'with two dependencies' do

    end

    context 'with a lot of dependencies' do

    end

  end

  context 'then, error or exception cases' do

    context 'with a not well-formed job' do

      it 'wrong symbol for dependency' do
        # skip
      end

      it 'wrong symbol for dependent job' do
        # skip
      end

      it 'wrong symbol for prior job' do
        # skip
      end

    end

    it 'dead lock dependency (when a job depends from itself)' do
      # skip
    end

    it 'circular dependencies' do
      # wow!
      # let's see after
      # skip
    end

  end

end
