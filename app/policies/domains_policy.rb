# frozen_string_literal: true

class DomainsPolicy < ApplicationPolicy
  def index?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    true
  end

  def show?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    true
  end

  def create?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:create), object_agent).grant?
  end

  def update?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:update), object_agent).grant?
  end

  def destroy?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:destroy), object_agent).grant?
  end
end
