# frozen_string_literal: true

require 'rails_helper'

require 'policy_errors'

RSpec.describe ApplicationPolicy, type: :policy do
  it_should_behave_like 'an application policy'

  describe 'application policy' do
    subject { application_policy }

    let(:application_policy) { described_class.new([subject_agent, object_agent]) }
    let(:subject_agent) { SubjectPolicyAgent.new(:Subject, subject_client) }
    let(:subject_client) { double('subject client') }
    let(:object_agent) { ObjectPolicyAgent.new(:Object, object_client) }
    let(:object_client) { double('object client') }

    it '#respond_to? (a.k.a. #respond_to_missing?)' do
      expect(subject.respond_to?(:action?)).to be true
      expect(subject.respond_to?(:action)).to be false
    end

    describe '#action?' do
      it do
        expect(subject.action?).to be false
        expect { subject.authorize!(:action?, nil) }.to raise_error(NotAuthorizedError)
        expect { subject.authorize!(:action, nil) }.to raise_error(NoMethodError)
      end
      context 'permission' do
        before { PolicyMaker.permit!(subject_agent, ActionPolicyAgent.new(:action), object_agent) }
        it do
          expect(subject.action?).to be true
          expect { subject.authorize!(:action?, nil) }.not_to raise_error
          expect { subject.authorize!(:action, nil) }.to raise_error(NoMethodError)
        end
      end
    end

    # describe '#administrator?' do
    #   subject { application_policy.administrator? }
    #   it { is_expected.to be false }
    #   context 'administrator' do
    #     before do
    #       before { PolicyMaker.permit!(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent) }
    #       it { is_expected.to be true }
    #     end
    #   end
    # end

    # describe '#administrator_agent?' do
    #   subject { application_policy.administrator_agent?(agent) }
    #   let(:agent) { NounPolicyAgent.new(:Agent, agent_client) }
    #   let(:agent_client) { double('agent client') }
    #   it { is_expected.to be false }
    #   context 'administrator' do
    #     before do
    #       before { PolicyMaker.permit!(agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent) }
    #       it { is_expected.to be true }
    #     end
    #   end
    # end
  end
end
