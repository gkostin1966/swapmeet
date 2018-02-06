# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PolicyMaker do
  let(:subject_agent) { SubjectPolicyAgent.new(:Entity, :subject) }
  let(:verb_agent) { VerbPolicyAgent.new(:Entity, :verb) }
  let(:object_agent) { ObjectPolicyAgent.new(:Entity, :object) }

  context 'policy' do
    let(:policy_resolver) { PolicyResolver.new(subject_agent, verb_agent, object_agent) }

    context 'ignore multiple calls' do
      it do
        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be false
        expect(policy_resolver.grant?).to be false
        expect(subject.permit!(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be true
        expect(policy_resolver.grant?).to be true
        expect(subject.permit!(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be true
        expect(policy_resolver.grant?).to be true
        expect(subject.revoke!(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be false
        expect(policy_resolver.grant?).to be false
        expect(subject.revoke!(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be false
        expect(policy_resolver.grant?).to be false
        expect(subject.permit!(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.permit!(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.permit!(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be true
        expect(policy_resolver.grant?).to be true
        expect(subject.revoke!(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be false
        expect(policy_resolver.grant?).to be false
      end
    end

    context 'specific and general policies' do
      let(:object_agent_type) { ObjectPolicyAgent.new(:Entity, nil) }
      let(:object_agent_any) { ObjectPolicyAgent.new(nil, nil) }

      it do
        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be false
        expect(subject.exists?(subject_agent, verb_agent, object_agent_type)).to be false
        expect(subject.exists?(subject_agent, verb_agent, object_agent_any)).to be false
        expect(policy_resolver.grant?).to be false

        expect(subject.permit!(subject_agent, verb_agent, object_agent)).to be true

        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent_type)).to be false
        expect(subject.exists?(subject_agent, verb_agent, object_agent_any)).to be false
        expect(policy_resolver.grant?).to be true

        expect(subject.permit!(subject_agent, verb_agent, object_agent_type)).to be true

        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent_type)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent_any)).to be false
        expect(policy_resolver.grant?).to be true

        expect(subject.permit!(subject_agent, verb_agent, object_agent_any)).to be true

        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent_type)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent_any)).to be true
        expect(policy_resolver.grant?).to be true

        expect(subject.revoke!(subject_agent, verb_agent, object_agent)).to be true

        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be false
        expect(subject.exists?(subject_agent, verb_agent, object_agent_type)).to be true
        expect(subject.exists?(subject_agent, verb_agent, object_agent_any)).to be true
        expect(policy_resolver.grant?).to be true


        expect(subject.revoke!(subject_agent, verb_agent, object_agent_type)).to be true

        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be false
        expect(subject.exists?(subject_agent, verb_agent, object_agent_type)).to be false
        expect(subject.exists?(subject_agent, verb_agent, object_agent_any)).to be true
        expect(policy_resolver.grant?).to be true

        expect(subject.revoke!(subject_agent, verb_agent, object_agent_any)).to be true

        expect(subject.exists?(subject_agent, verb_agent, object_agent)).to be false
        expect(subject.exists?(subject_agent, verb_agent, object_agent_type)).to be false
        expect(subject.exists?(subject_agent, verb_agent, object_agent_any)).to be false
        expect(policy_resolver.grant?).to be false
      end
    end
  end
end
