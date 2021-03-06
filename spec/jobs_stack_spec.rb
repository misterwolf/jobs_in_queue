require 'spec_helper'
require_relative '../lib/jobs_stack'

# preferring BDD!

describe "JobsStack" do

  context 'first step: testing simple cases' do
    context 'with no jobs' do

      it 'return an empty sequence' do
        jobs_in_queue = JobsStack.new('')
        expect(jobs_in_queue.sort_jobs_list).to eq []
      end

    end

    context 'with one or more jobs ' do

      it 'return a sequence with single job' do
        jobs_stack = JobsStack.new('a =>')
        expect(jobs_stack.sort_jobs_list).to eq ['a']
      end

      it 'return a sequence with two jobs' do
        jobs_stack = JobsStack.new('a =>\nb =>')
        expect(jobs_stack.sort_jobs_list).to eq ['a','b']
      end

      it 'return a sequence with two jobs (with \n escaped)' do
        jobs_stack = JobsStack.new("a =>\nb =>")
        expect(jobs_stack.sort_jobs_list).to eq ['a','b']
      end

      it 'return a sequence with more unsorted jobs' do
        jobs_stack = JobsStack.new('c =>\na =>\nb =>\n')
        expect(jobs_stack.sort_jobs_list).to eq ['a','b','c']
      end

    end

  end

  context 'then, more complex cases: ' do

    context 'with one dependency' do

      context 'passing this queue => "a =>\nb => c\nc =>\n"' do
        let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc =>\n") }
        it 'have a sequence sorted with a at first position, then c, then b' do
          expect(jobs_stack.sort).to eq ['a','c','b']
        end
      end

      context 'passing this queue => "a =>b\nb =>\nc =>\n"' do
        let(:jobs_stack) { JobsStack.new("a =>b\nb =>\nc =>\n") }
        it 'have a sequence sorted with c at first position, then b, then a' do
          expect(jobs_stack.sort).to eq ['b', 'a', 'c']
        end
      end

    end
    context 'with two dependency' do
      context 'into a total of three jobs' do

        context 'passing this queue a =>\nb => c\nc =>a\n' do

          let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc =>a\n") }
          it 'have this sequence sorted with a, then c, then b' do
            expect(jobs_stack.sort).to eq ['a','c','b']
          end

        end
      end

      context 'into a total of four jobs' do
        context 'passing this queue a =>\nb => c\nc => d\nd => \n' do
          let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc => d\nd => \n") }
          it 'have a sequence sorted with a then d then c and the last is b' do
            expect(jobs_stack.sort).to eq ['a', 'd','c','b']
          end
          it 'have a sequence sorted alphatecally: ["a","b","c","d"]' do
            expect(jobs_stack.sort_jobs_list).to eq ['a','b','c','d']
          end
        end
      end

    end

    context 'with a lot of dependencies' do
      context 'into a total of five jobs with common dependencies' do

        context 'passing this queue a =>\nb => c\nc =>a\nd=>\ne=>a' do
          let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc =>a\nd=>a\ne=>a") }
          it 'have a sequence sorted with a, then c, then b, then d and then e' do
            expect(jobs_stack.sort).to eq ['a','c','b','d','e']
          end

        end
      end

      # the one proposed from the OTB:
      context 'into a total of six jobs' do
        context 'passing this queue a =>\nb => c\nc => f\nd => a\ne =>b\nf =>\n' do
          let(:jobs_stack) { JobsStack.new("a =>\nb => c\nc => f\nd => a\ne => b\nf =>\n") }
          it 'f before c, c before b, b before e and a before d' do
            expect(jobs_stack.sort).to eq ['a','f','c','b','d','e']
            # I completely misunderstood the initial purpose of the test.
            # At first I assumed that the sequence had to be this:
            # [a,d,f,c,b,d,e]
            # instead, important is that related jobs are insrted BEFORE of the dependent one.
          end
        end
      end
    end
  end

  context 'then, error or exception cases' do

    xcontext 'with a not well-formed job' do # not required!!

      xit 'wrong symbol for dependency' do
      end

      xit 'wrong symbol for dependent job' do
      end

      xit 'wrong symbol for prior job' do
      end

    end

    it 'Job depends on its self ("a =>\nb => b")' do
      expect{JobsStack.new("a =>\nb => b").sort}.to raise_exception(
          JobsStack::SelfDependencyError,
          "this job => b depends on itself"
        )
    end

    context 'circular dependencies' do
      it 'when adjacent' do
        expect{JobsStack.new("a =>b\nb => c\nc =>b").sort}.to raise_exception(
            JobsStack::CircularDependencyError,
            "these jobs => b => c depends each other"
          )
      end
      it 'when distant' do
        expect{JobsStack.new("a =>b\nb => c\nc =>a").sort}.to raise_exception(
            JobsStack::CircularDependencyError,
            "these jobs => a => b depends each other"
          )
      end
    end

  end

end
