# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublishersPolicy, type: :policy do
  subject { policy }

  let(:policy) { described_class.new([subject_agent, object_agent]) }
  let(:subject_agent) { SubjectPolicyAgent.new(:User, current_user) }
  let(:current_user) { double('current user') }
  let(:object_agent) { ObjectPolicyAgent.new(:Publisher, publisher) }
  let(:publisher) { double('publisher') }

  let(:anonymous) { false }
  let(:authenticated) { false }
  let(:identified) { false }
  let(:administrative) { false }

  before do
    allow(subject_agent).to receive(:client_instance_anonymous?).and_return(anonymous)
    allow(subject_agent).to receive(:client_instance_authenticated?).and_return(authenticated)
    allow(subject_agent).to receive(:client_instance_identified?).and_return(identified)
    allow(subject_agent).to receive(:client_instance_administrative?).and_return(administrative)
  end

  it { is_expected.to be_a ApplicationPolicy }

  context "Anonymous" do
    let(:anonymous) { true }
    VerbPolicyAgent::VERB_TYPES.each do |verb_type|
      case verb_type
      when :Action
        ActionPolicyAgent::ACTIONS.each do |action|
          context "#{action}?" do
            if %i[action index show].include?(action)
              it { expect(subject.send("#{action}?")).to be true }
            else
              it { expect(subject.send("#{action}?")).to be false }
            end
            context 'Grant' do
              let(:action_agent) { ActionPolicyAgent.new(action) }
              before { PolicyMaker.permit!(subject_agent, action_agent, object_agent) }
              if %i[action index show].include?(action)
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

  context "Identified Authenticated" do
    let(:authenticated) { true }
    VerbPolicyAgent::VERB_TYPES.each do |verb_type|
      case verb_type
      when :Action
        ActionPolicyAgent::ACTIONS.each do |action|
          context "#{action}?" do
            if %i[action index show].include?(action)
              it { expect(subject.send("#{action}?")).to be true }
            else
              it { expect(subject.send("#{action}?")).to be false }
            end
            context 'Grant' do
              let(:action_agent) { ActionPolicyAgent.new(action) }
              before { PolicyMaker.permit!(subject_agent, action_agent, object_agent) }
              if %i[action add index join leave remove show].include?(action)
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


  context "Identified" do
    let(:authenticated) { true }
    let(:identified) { true }
    VerbPolicyAgent::VERB_TYPES.each do |verb_type|
      case verb_type
      when :Action
        ActionPolicyAgent::ACTIONS.each do |action|
          context "#{action}?" do
            if %i[action index show].include?(action)
              it { expect(subject.send("#{action}?")).to be true }
            else
              it { expect(subject.send("#{action}?")).to be false }
            end
            context 'Grant' do
              let(:action_agent) { ActionPolicyAgent.new(action) }
              before { PolicyMaker.permit!(subject_agent, action_agent, object_agent) }
              if %i[action add create delete destroy edit join leave index new remove show update].include?(action)
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
              if %i[policy permit revoke].include?(policy)
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
              if %i[role administrator].include?(role)
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

  context "Administrative" do
    let(:authenticated) { true }
    let(:identified) { true }
    let(:administrative) { true }
    VerbPolicyAgent::VERB_TYPES.each do |verb_type|
      case verb_type
      when :Action
        ActionPolicyAgent::ACTIONS.each do |action|
          context "#{action}?" do
            if %i[action add create delete destroy edit index join leave new remove show update].include?(action)
              it { expect(subject.send("#{action}?")).to be true }
            else
              it { expect(subject.send("#{action}?")).to be false }
            end
            context 'Grant' do
              let(:action_agent) { ActionPolicyAgent.new(action) }
              before { PolicyMaker.permit!(subject_agent, action_agent, object_agent) }
              if %i[action add create delete destroy edit index join leave new remove show update].include?(action)
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
            if %i[policy permit revoke].include?(policy)
              it { expect(subject.send("#{policy}?")).to be true }
            else
              it { expect(subject.send("#{policy}?")).to be false }
            end
            context 'Grant' do
              let(:policy_agent) { PolicyPolicyAgent.new(policy) }
              before { PolicyMaker.permit!(subject_agent, policy_agent, object_agent) }
              if %i[policy permit revoke].include?(policy)
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
            if %i[role administrator].include?(role)
              it { expect(subject.send("#{role}?")).to be true }
            else
              it { expect(subject.send("#{role}?")).to be false }
            end
            context 'Grant' do
              let(:role_agent) { RolePolicyAgent.new(role) }
              before { PolicyMaker.permit!(subject_agent, role_agent, object_agent) }
              if %i[role administrator].include?(role)
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
