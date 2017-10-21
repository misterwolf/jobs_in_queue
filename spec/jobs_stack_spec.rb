require 'spec_helper'
require_relative '../lib/jobs_stack'

# preferring BDD!

describe "JobsStack" do

  context 'first step: testing the simple cases' do

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

  context 'then, more complex cases: ' do

    context 'with one dependency' do
      context 'into a total of three jobs' do

        context 'passing this queue => "a =>\nb => c\nc =>\n"' do
          let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc =>\n") }

          it 'have a sequence sorted with c at first position, then b, then a' do
            expect(jobs_stack.sorted_jobs).to eq ['c','b','a']
          end
        end

        context 'passing this queue => "a =>b\nb =>\nc =>\n"' do
          let(:jobs_stack) { JobsStack.new("a =>b\nb =>\nc =>\n") }

          it 'have a sequence sorted with b at first position, then a, then c' do
            expect(jobs_stack.sorted_jobs).to eq ['b','a','c']
          end
        end

      end
    end
    context 'with two dependency' do
      context 'into a total of three jobs' do

        context 'passing this queue a =>\nb => c\nc =>a\n' do

          let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc =>a\n") }
          it 'have a sequence sorted with c, then b, before a' do
            expect(jobs_stack.sorted_jobs).to eq ['c','b','a']
          end

        end
      end

      context 'into a total of four jobs' do
        context 'passing this queue a =>\nb => c\nc => d\nd => \n' do
          let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc => d\nd => \n") }

          it 'have a sequence sorted with d then c then b and the last is a' do
            expect(jobs_stack.sorted_jobs).to eq ['d','c','b','a']
          end
          it 'have a sequence sorted alphatecally' do
            expect(jobs_stack.queue).to eq ['a','b','c','d']
          end
        end
      end

    end

    context 'with a lot of dependencies' do
      context 'into a total of five jobs' do

        context 'passing this queue a =>\nb => c\nc =>a\nd=>\ne=>a' do

          let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc =>a\nd=>\ne=>a") }
          it 'have a sequence sorted with a, then c, then b, then e and then d' do
            expect(jobs_stack.sorted_jobs).to eq ['c','b','e','d','a']
          end

        end
      end

    end

  end

  context 'then, error or exception cases' do

    context 'with a not well-formed job' do

      it 'wrong symbol for dependency' do
        # 
      end

      it 'wrong symbol for dependent job' do
        # 
      end

      it 'wrong symbol for prior job' do
        # 
      end

    end

    it 'dead lock dependency (when a job depends from itself)' do
      # 
    end

    it 'circular dependencies' do
      # wow!
      # let's see after
      # 
    end

    it 'all jobs are dependents' do
    end

  end

end
