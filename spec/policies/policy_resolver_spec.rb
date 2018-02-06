# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PolicyResolver do
  let(:policy_resolver) { described_class.new(subject_agent_id, verb_agent_id, object_agent_id) }

  let(:subject_agent_any) { SubjectPolicyAgent.new(nil, nil) }
  let(:subject_agent_type) { SubjectPolicyAgent.new(:Entity, nil) }
  let(:subject_agent_id) { SubjectPolicyAgent.new(:Entity, :subject) }
  let(:verb_agent_any) { VerbPolicyAgent.new(nil, nil) }
  let(:verb_agent_type) { VerbPolicyAgent.new(:Entity, nil) }
  let(:verb_agent_id) { VerbPolicyAgent.new(:Entity, :verb) }
  let(:object_agent_any) { ObjectPolicyAgent.new(nil, nil) }
  let(:object_agent_type) { ObjectPolicyAgent.new(:Entity, nil) }
  let(:object_agent_id) { ObjectPolicyAgent.new(:Entity, :object) }

  describe '#grant?' do
    subject { policy_resolver.grant? }

    context 'no policy (empty table) no access' do
      it { is_expected.to be false }
    end

    context 'null policy (single null row in table) full access' do
      before { Gatekeeper.new.save! }
      it { is_expected.to be true }
    end

    context 'non-empty table without null row gives selective access' do
      it 'explicit policy' do
        is_expected.to be false
        PolicyMaker.permit!(subject_agent_id, verb_agent_id, object_agent_id)
        expect(policy_resolver.grant?).to be true
        PolicyMaker.revoke!(subject_agent_id, verb_agent_id, object_agent_id)
        expect(policy_resolver.grant?).to be false
      end

      it 'explicit subject and verb policy' do
        is_expected.to be false
        PolicyMaker.permit!(subject_agent_id, verb_agent_id, object_agent_type)
        expect(policy_resolver.grant?).to be true
        PolicyMaker.revoke!(subject_agent_id, verb_agent_id, object_agent_type)
        expect(policy_resolver.grant?).to be false
      end

      it 'explicit subject and object policy' do
        is_expected.to be false
        PolicyMaker.permit!(subject_agent_id, verb_agent_type, object_agent_id)
        expect(policy_resolver.grant?).to be true
        PolicyMaker.revoke!(subject_agent_id, verb_agent_type, object_agent_id)
        expect(policy_resolver.grant?).to be false
      end

      it 'explicit subject policy' do
        is_expected.to be false
        PolicyMaker.permit!(subject_agent_id, verb_agent_type, object_agent_type)
        expect(policy_resolver.grant?).to be true
        PolicyMaker.revoke!(subject_agent_id, verb_agent_type, object_agent_type)
        expect(policy_resolver.grant?).to be false
      end

      it 'explicit verb and object policy' do
        is_expected.to be false
        PolicyMaker.permit!(subject_agent_type, verb_agent_id, object_agent_id)
        expect(policy_resolver.grant?).to be true
        PolicyMaker.revoke!(subject_agent_type, verb_agent_id, object_agent_id)
        expect(policy_resolver.grant?).to be false
      end

      it 'explicit verb policy' do
        is_expected.to be false
        PolicyMaker.permit!(subject_agent_type, verb_agent_id, object_agent_type)
        expect(policy_resolver.grant?).to be true
        PolicyMaker.revoke!(subject_agent_type, verb_agent_id, object_agent_type)
        expect(policy_resolver.grant?).to be false
      end

      it 'explicit object policy' do
        is_expected.to be false
        PolicyMaker.permit!(subject_agent_type, verb_agent_type, object_agent_id)
        expect(policy_resolver.grant?).to be true
        PolicyMaker.revoke!(subject_agent_type, verb_agent_type, object_agent_id)
        expect(policy_resolver.grant?).to be false
      end

      it 'implicit policy' do
        is_expected.to be false
        PolicyMaker.permit!(subject_agent_type, verb_agent_type, object_agent_type)
        expect(policy_resolver.grant?).to be true
        PolicyMaker.revoke!(subject_agent_type, verb_agent_type, object_agent_type)
        expect(policy_resolver.grant?).to be false
      end
    end
  end
end
