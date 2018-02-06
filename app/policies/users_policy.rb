# frozen_string_literal: true

class UsersPolicy < ApplicationPolicy
  def index?
    return false unless subject_user?
    return false unless object_agent.client_type == :User.to_s
    return true unless agents.count > 2
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, agents[-2]).grant?
    return false unless agents.count > 3
    PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, agents[-3]).grant?
  end

  def show?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    return true unless agents.count > 2
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, agents[-2]).grant?
    return false unless agents.count > 3
    PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, agents[-3]).grant?
  end

  def create?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:create), object_agent).grant?
  end

  def update?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    return true if subject_agent.client == object_agent.client
    return true if subject_administrative_user?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:update), object_agent).grant?
  end

  def destroy?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:destroy), object_agent).grant?
  end

  def add?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    return false unless object_agent.client_type == :User.to_s
    return false unless agents.count > 2
    return true if subject_administrative_user?
    return true if PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:add), agents[-2]).grant?
    return false unless agents.count > 3
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, agents[-3])
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:add), agents[-3]).grant?
  end

  def remove?
    return false unless subject_authenticated_user?
    return false unless object_agent.client_type == :User.to_s
    return false unless agents.count > 2
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:remove), agents[-2]).grant?
    return false unless agents.count > 3
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, agents[-3])
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:remove), agents[-3]).grant?
  end
end
