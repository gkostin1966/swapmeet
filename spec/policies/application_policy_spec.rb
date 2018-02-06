# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy, type: :policy do
  subject { policy }

  let(:policy) { described_class.new([subject_agent, object_agent]) }
  let(:subject_agent) { SubjectPolicyAgent.new(subject_type, :entity) }
  let(:subject_type) { :Entity }
  let(:object_agent) { ObjectPolicyAgent.new(:Entity, :entity) }

  it { is_expected.to be_a ApplicationPolicy }

  SubjectPolicyAgent::SUBJECT_TYPES.each do |subject_type|
    context "#{subject_type}" do
      let(:subject_type) { subject_type }

      if %i[User].include?(subject_type)
        [false, true].each do |authenticated|
          context "#authenticated? #{authenticated}" do
            before { allow(subject_agent).to receive(:authenticated?).and_return(authenticated) }
            VerbPolicyAgent::VERB_TYPES.each do |verb_type|
              case verb_type
              when :Action
                ActionPolicyAgent::ACTIONS.each do |action|
                  context "#{action}?" do
                    if %i[action].include?(action)
                      it { expect(subject.send("#{action}?")).to be true }
                    else
                      it { expect(subject.send("#{action}?")).to be false }
                    end
                    context 'Grant' do
                      let(:action_agent) { ActionPolicyAgent.new(action) }
                      before { PolicyMaker.permit!(subject_agent, action_agent, object_agent) }
                      if %i[action].include?(action)
                        it { expect(subject.send("#{action}?")).to be true }
                      else
                        it { expect(subject.send("#{action}?")).to be false }
                      end
                    end
                  end
                end
              when :Entity
                next
              when :Policy
                PolicyPolicyAgent::POLICIES.each do |policy|
                  context "#{policy}?" do
                    it { expect(subject.send("#{policy}?")).to be false }
                    context 'Grant' do
                      let(:policy_agent) { PolicyPolicyAgent.new(policy) }
                      before { PolicyMaker.permit!(subject_agent, policy_agent, object_agent) }
                      if %i[policy].include?(policy)
                        it { expect(subject.send("#{policy}?")).to be true }
                      else
                        it { expect(subject.send("#{policy}?")).to be false }
                      end
                    end
                  end
                end
              when :Role
                RolePolicyAgent::ROLES.each do |role|
                  context "#{role}?" do
                    it { expect(subject.send("#{role}?")).to be false }
                    context 'Grant' do
                      let(:role_agent) { RolePolicyAgent.new(role) }
                      before { PolicyMaker.permit!(subject_agent, role_agent, object_agent) }
                      if %i[role].include?(role)
                        it { expect(subject.send("#{role}?")).to be true }
                      else
                        it { expect(subject.send("#{role}?")).to be false }
                      end
                    end
                  end
                end
              else
                raise VerbTypeError
              end
            end
          end
        end
      else
        VerbPolicyAgent::VERB_TYPES.each do |verb_type|
          case verb_type
          when :Action
            ActionPolicyAgent::ACTIONS.each do |action|
              context "#{action}?" do
                it { expect(subject.send("#{action}?")).to be false }
                context 'Grant' do
                  let(:action_agent) { ActionPolicyAgent.new(action) }
                  before { PolicyMaker.permit!(subject_agent, action_agent, object_agent) }
                  if %i[action].include?(action)
                    it { expect(subject.send("#{action}?")).to be true }
                  else
                    it { expect(subject.send("#{action}?")).to be false }
                  end
                end
              end
            end
          when :Entity
            next
          when :Policy
            PolicyPolicyAgent::POLICIES.each do |policy|
              context "#{policy}?" do
                it { expect(subject.send("#{policy}?")).to be false }
                context 'Grant' do
                  let(:policy_agent) { PolicyPolicyAgent.new(policy) }
                  before { PolicyMaker.permit!(subject_agent, policy_agent, object_agent) }
                  if %i[policy].include?(policy)
                    it { expect(subject.send("#{policy}?")).to be true }
                  else
                    it { expect(subject.send("#{policy}?")).to be false }
                  end
                end
              end
            end
          when :Role
            RolePolicyAgent::ROLES.each do |role|
              context "#{role}?" do
                it { expect(subject.send("#{role}?")).to be false }
                context 'Grant' do
                  let(:role_agent) { RolePolicyAgent.new(role) }
                  before { PolicyMaker.permit!(subject_agent, role_agent, object_agent) }
                  if %i[role].include?(role)
                    it { expect(subject.send("#{role}?")).to be true }
                  else
                    it { expect(subject.send("#{role}?")).to be false }
                  end
                end
              end
            end
          else
            raise VerbTypeError
          end
        end
      end
    end
  end
end
