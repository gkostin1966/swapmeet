# frozen_string_literal: true

require 'rails_helper'

require 'policy_errors'

RSpec.describe Policy, type: :policy do
  subject { policy }

  let(:policy) { described_class.new([subject_agent, object_agent]) }
  let(:subject_agent) { SubjectPolicyAgent.new(:Entity, subject_client) }
  let(:subject_client) { double('subject client') }
  let(:object_agent) { ObjectPolicyAgent.new(:Entity, object_client) }
  let(:object_client) { double('object client') }

  describe '#respond_to? (a.k.a. #respond_to_missing?)' do
    it do
      expect(subject.respond_to?(:unknown?)).to be false
      expect(subject.respond_to?(:unknown)).to be false
      expect { subject.send(:unknown?) }.to raise_error(NoMethodError)
      expect { subject.send(:unknown) }.to raise_error(NoMethodError)
      expect { subject.authorize!(:unknown?, nil) }.to raise_error(NoMethodError)
      expect { subject.authorize!(:unknown, nil) }.to raise_error(NoMethodError)
    end
  end

  describe 'actions' do
    ActionPolicyAgent::ACTIONS.each do |action|
      it do
        expect(subject.respond_to?("#{action}?")).to be true
        expect(subject.respond_to?("#{action}")).to be false
        expect(subject.send("#{action}?")).to be false
        expect { subject.authorize!(:"#{action}?", nil) }.to raise_error(NotAuthorizedError)
        expect { subject.authorize!(:"#{action}", nil) }.to raise_error(NoMethodError)
      end
    end
  end

  describe 'policies' do
    PolicyPolicyAgent::POLICIES.each do |policy|
      it do
        expect(subject.respond_to?("#{policy}?")).to be true
        expect(subject.respond_to?("#{policy}")).to be false
        expect(subject.send("#{policy}?")).to be false
        expect { subject.authorize!(:"#{policy}?", nil) }.to raise_error(NotAuthorizedError)
        expect { subject.authorize!(:"#{policy}", nil) }.to raise_error(NoMethodError)
      end
    end
  end

  describe 'roles' do
    RolePolicyAgent::ROLES.each do |role|
      it do
        expect(subject.respond_to?("#{role}?")).to be true
        expect(subject.respond_to?("#{role}")).to be false
        expect(subject.send("#{role}?")).to be false
        expect { subject.authorize!(:"#{role}?", nil) }.to raise_error(NotAuthorizedError)
        expect { subject.authorize!(:"#{role}", nil) }.to raise_error(NoMethodError)
      end
    end
  end
end
