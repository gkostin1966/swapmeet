# frozen_string_literal: true

class ListingsPolicy < ApplicationPolicy
  def index?
    return false unless subject_user?
    true
  end

  def show?
    return false unless subject_user?
    true
  end

  def create?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    true
  end

  def update?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    # return true if object_agent.creator?(subject_agent.client)
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:update), object_agent).grant?
  end

  def destroy?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    # return true if object_agent.creator?(subject_agent.client)
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:destroy), object_agent).grant?
  end

  def add?
    subject_administrative_user?
  end

  def remove?
    subject_administrative_user?
  end
end
