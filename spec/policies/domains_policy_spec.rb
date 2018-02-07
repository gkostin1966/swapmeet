# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DomainsPolicy, type: :policy do
  matrix = PoliciessHelper::PolicyMatrix.new

  # matrix.expected("administrative_Action_create_permit")
  # matrix.expected("administrative_Action_create_revoke")
  # matrix.expected("administrative_Action_destroy_permit")
  # matrix.expected("administrative_Action_destroy_revoke")
  # matrix.expected("administrative_Action_index_permit")
  # matrix.expected("administrative_Action_index_revoke")
  # matrix.expected("administrative_Action_update_permit")
  # matrix.expected("administrative_Action_update_revoke")
  # matrix.expected("administrative_Action_show_permit")
  # matrix.expected("administrative_Action_show_revoke")
  #
  # matrix.expected("anonymous_Action_create_permit")
  # matrix.expected("anonymous_Action_create_revoke")
  # matrix.expected("anonymous_Action_destroy_permit")
  # matrix.expected("anonymous_Action_destroy_revoke")
  # matrix.expected("anonymous_Action_index_permit")
  # matrix.expected("anonymous_Action_index_revoke")
  # matrix.expected("anonymous_Action_update_permit")
  # matrix.expected("anonymous_Action_update_revoke")
  # matrix.expected("anonymous_Action_show_permit")
  # matrix.expected("anonymous_Action_show_revoke")
  #
  # matrix.expected("authenticated_Action_create_permit")
  # matrix.expected("authenticated_Action_create_revoke")
  # matrix.expected("authenticated_Action_destroy_permit")
  # matrix.expected("authenticated_Action_destroy_revoke")
  # matrix.expected("authenticated_Action_index_permit")
  # matrix.expected("authenticated_Action_index_revoke")
  # matrix.expected("authenticated_Action_update_permit")
  # matrix.expected("authenticated_Action_update_revoke")
  # matrix.expected("authenticated_Action_show_permit")
  # matrix.expected("authenticated_Action_show_revoke")
  #
  # matrix.expected("identified_Action_create_permit")
  # matrix.expected("identified_Action_create_revoke")
  # matrix.expected("identified_Action_destroy_permit")
  # matrix.expected("identified_Action_destroy_revoke")
  # matrix.expected("identified_Action_index_permit")
  # matrix.expected("identified_Action_index_revoke")
  # matrix.expected("identified_Action_update_permit")
  # matrix.expected("identified_Action_update_revoke")
  # matrix.expected("identified_Action_show_permit")
  # matrix.expected("identified_Action_show_revoke")

  it_should_behave_like 'policy matrix', :Domain, matrix
#
#   subject { policy }
#
#   let(:policy) { described_class.new([subject_agent, object_agent]) }
#   let(:subject_agent) { SubjectPolicyAgent.new(:User, current_user) }
#   let(:current_user) { double('current user') }
#   let(:object_agent) { ObjectPolicyAgent.new(:Domain, domain) }
#   let(:domain) { double('domain') }
#
#   let(:anonymous) { false }
#   let(:authenticated) { false }
#   let(:identified) { false }
#   let(:administrative) { false }
#
#   before do
#     allow(subject_agent).to receive(:client_instance_anonymous?).and_return(anonymous)
#     allow(subject_agent).to receive(:client_instance_authenticated?).and_return(authenticated)
#     allow(subject_agent).to receive(:client_instance_identified?).and_return(identified)
#     allow(subject_agent).to receive(:client_instance_administrative?).and_return(administrative)
#   end
#
#   it { is_expected.to be_a ApplicationPolicy }
#
#   context "Anonymous" do
#     let(:anonymous) { true }
#     VerbPolicyAgent::VERB_TYPES.each do |verb_type|
#       case verb_type
#       when :Action
#         ActionPolicyAgent::ACTIONS.each do |action|
#           context "#{action}?" do
#             if %i[action].include?(action)
#               it { expect(subject.send("#{action}?")).to be true }
#             else
#               it { expect(subject.send("#{action}?")).to be false }
#             end
#             context 'Grant' do
#               let(:action_agent) { ActionPolicyAgent.new(action) }
#               before { PolicyMaker.permit!(subject_agent, action_agent, object_agent) }
#               if %i[action].include?(action)
#                 it { expect(subject.send("#{action}?")).to be true }
#               else
#                 it { expect(subject.send("#{action}?")).to be false }
#               end
#             end
#           end
#         end
#       when :Entity
#         next
#       when :Policy
#         PolicyPolicyAgent::POLICIES.each do |policy|
#           context "#{policy}?" do
#             it { expect(subject.send("#{policy}?")).to be false }
#             context 'Grant' do
#               let(:policy_agent) { PolicyPolicyAgent.new(policy) }
#               before { PolicyMaker.permit!(subject_agent, policy_agent, object_agent) }
#               if %i[policy].include?(policy)
#                 it { expect(subject.send("#{policy}?")).to be true }
#               else
#                 it { expect(subject.send("#{policy}?")).to be false }
#               end
#             end
#           end
#         end
#       when :Role
#         RolePolicyAgent::ROLES.each do |role|
#           context "#{role}?" do
#             it { expect(subject.send("#{role}?")).to be false }
#             context 'Grant' do
#               let(:role_agent) { RolePolicyAgent.new(role) }
#               before { PolicyMaker.permit!(subject_agent, role_agent, object_agent) }
#               if %i[role].include?(role)
#                 it { expect(subject.send("#{role}?")).to be true }
#               else
#                 it { expect(subject.send("#{role}?")).to be false }
#               end
#             end
#           end
#         end
#       else
#         raise VerbTypeError
#       end
#     end
#   end
#
#   context "Authenticated" do
#     let(:authenticated) { true }
#     VerbPolicyAgent::VERB_TYPES.each do |verb_type|
#       case verb_type
#       when :Action
#         ActionPolicyAgent::ACTIONS.each do |action|
#           context "#{action}?" do
#             if %i[action index show].include?(action)
#               it { expect(subject.send("#{action}?")).to be true }
#             else
#               it { expect(subject.send("#{action}?")).to be false }
#             end
#             context 'Grant' do
#               let(:action_agent) { ActionPolicyAgent.new(action) }
#               before { PolicyMaker.permit!(subject_agent, action_agent, object_agent) }
#               if %i[action index show create destroy update].include?(action)
#                 it { expect(subject.send("#{action}?")).to be true }
#               else
#                 it { expect(subject.send("#{action}?")).to be false }
#               end
#             end
#           end
#         end
#       when :Entity
#         next
#       when :Policy
#         PolicyPolicyAgent::POLICIES.each do |policy|
#           context "#{policy}?" do
#             it { expect(subject.send("#{policy}?")).to be false }
#             context 'Grant' do
#               let(:policy_agent) { PolicyPolicyAgent.new(policy) }
#               before { PolicyMaker.permit!(subject_agent, policy_agent, object_agent) }
#               if %i[policy].include?(policy)
#                 it { expect(subject.send("#{policy}?")).to be true }
#               else
#                 it { expect(subject.send("#{policy}?")).to be false }
#               end
#             end
#           end
#         end
#       when :Role
#         RolePolicyAgent::ROLES.each do |role|
#           context "#{role}?" do
#             it { expect(subject.send("#{role}?")).to be false }
#             context 'Grant' do
#               let(:role_agent) { RolePolicyAgent.new(role) }
#               before { PolicyMaker.permit!(subject_agent, role_agent, object_agent) }
#               if %i[role].include?(role)
#                 it { expect(subject.send("#{role}?")).to be true }
#               else
#                 it { expect(subject.send("#{role}?")).to be false }
#               end
#             end
#           end
#         end
#       else
#         raise VerbTypeError
#       end
#     end
#   end
#
#   context "Identified" do
#     let(:authenticated) { true }
#     let(:identified) { true }
#     VerbPolicyAgent::VERB_TYPES.each do |verb_type|
#       case verb_type
#       when :Action
#         ActionPolicyAgent::ACTIONS.each do |action|
#           context "#{action}?" do
#             if %i[action index show].include?(action)
#               it { expect(subject.send("#{action}?")).to be true }
#             else
#               it { expect(subject.send("#{action}?")).to be false }
#             end
#             context 'Grant' do
#               let(:action_agent) { ActionPolicyAgent.new(action) }
#               before { PolicyMaker.permit!(subject_agent, action_agent, object_agent) }
#               if %i[action index show create destroy update].include?(action)
#                 it { expect(subject.send("#{action}?")).to be true }
#               else
#                 it { expect(subject.send("#{action}?")).to be false }
#               end
#             end
#           end
#         end
#       when :Entity
#         next
#       when :Policy
#         PolicyPolicyAgent::POLICIES.each do |policy|
#           context "#{policy}?" do
#             it { expect(subject.send("#{policy}?")).to be false }
#             context 'Grant' do
#               let(:policy_agent) { PolicyPolicyAgent.new(policy) }
#               before { PolicyMaker.permit!(subject_agent, policy_agent, object_agent) }
#               if %i[policy].include?(policy)
#                 it { expect(subject.send("#{policy}?")).to be true }
#               else
#                 it { expect(subject.send("#{policy}?")).to be false }
#               end
#             end
#           end
#         end
#       when :Role
#         RolePolicyAgent::ROLES.each do |role|
#           context "#{role}?" do
#             it { expect(subject.send("#{role}?")).to be false }
#             context 'Grant' do
#               let(:role_agent) { RolePolicyAgent.new(role) }
#               before { PolicyMaker.permit!(subject_agent, role_agent, object_agent) }
#               if %i[role].include?(role)
#                 it { expect(subject.send("#{role}?")).to be true }
#               else
#                 it { expect(subject.send("#{role}?")).to be false }
#               end
#             end
#           end
#         end
#       else
#         raise VerbTypeError
#       end
#     end
#   end
#
#   context "Administrative" do
#     let(:authenticated) { true }
#     let(:identified) { true }
#     let(:administrative) { true }
#     VerbPolicyAgent::VERB_TYPES.each do |verb_type|
#       case verb_type
#       when :Action
#         ActionPolicyAgent::ACTIONS.each do |action|
#           context "#{action}?" do
#             if %i[action create destroy index show update].include?(action)
#               it { expect(subject.send("#{action}?")).to be true }
#             else
#               it { expect(subject.send("#{action}?")).to be false }
#             end
#             context 'Grant' do
#               let(:action_agent) { ActionPolicyAgent.new(action) }
#               before { PolicyMaker.permit!(subject_agent, action_agent, object_agent) }
#               if %i[action index show create destroy update].include?(action)
#                 it { expect(subject.send("#{action}?")).to be true }
#               else
#                 it { expect(subject.send("#{action}?")).to be false }
#               end
#             end
#           end
#         end
#       when :Entity
#         next
#       when :Policy
#         PolicyPolicyAgent::POLICIES.each do |policy|
#           context "#{policy}?" do
#             it { expect(subject.send("#{policy}?")).to be false }
#             context 'Grant' do
#               let(:policy_agent) { PolicyPolicyAgent.new(policy) }
#               before { PolicyMaker.permit!(subject_agent, policy_agent, object_agent) }
#               if %i[policy].include?(policy)
#                 it { expect(subject.send("#{policy}?")).to be true }
#               else
#                 it { expect(subject.send("#{policy}?")).to be false }
#               end
#             end
#           end
#         end
#       when :Role
#         RolePolicyAgent::ROLES.each do |role|
#           context "#{role}?" do
#             it { expect(subject.send("#{role}?")).to be false }
#             context 'Grant' do
#               let(:role_agent) { RolePolicyAgent.new(role) }
#               before { PolicyMaker.permit!(subject_agent, role_agent, object_agent) }
#               if %i[role].include?(role)
#                 it { expect(subject.send("#{role}?")).to be true }
#               else
#                 it { expect(subject.send("#{role}?")).to be false }
#               end
#             end
#           end
#         end
#       else
#         raise VerbTypeError
#       end
#     end
#   end
end
