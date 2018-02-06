# frozen_string_literal: true

class ListingsPolicy < ApplicationPolicy
  def index?
    return false unless subject_agent.client_type == :User.to_s
    true
  end

  def show?
    return false unless subject_agent.client_type == :User.to_s
    true
  end

  def create?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    true
  end

  def update?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    # return true if object_agent.creator?(subject_agent.client)
    return true if subject_agent.administrator?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:update), object_agent).grant?
  end

  def destroy?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    # return true if object_agent.creator?(subject_agent.client)
    return true if subject_agent.administrator?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:destroy), object_agent).grant?
  end
end
