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

  it '#respond_to? (a.k.a. #respond_to_missing?)' do
    expect(subject.respond_to?(:action?)).to be true
    expect(subject.respond_to?(:action)).to be false
  end

  describe '#verb?' do
    it do
      expect(subject.verb?).to be false
      expect { subject.authorize!(:verb?, nil) }.to raise_error(NotAuthorizedError)
      expect { subject.authorize!(:verb, nil) }.to raise_error(NoMethodError)
    end
    context 'permission' do
      before { PolicyMaker.permit!(subject_agent, VerbPolicyAgent.new(:Entity, :verb), object_agent) }
      it do
        expect(subject.verb?).to be true
        expect { subject.authorize!(:verb?, nil) }.not_to raise_error
        expect { subject.authorize!(:verb, nil) }.to raise_error(NoMethodError)
      end
    end
  end
end
