# frozen_string_literal: true

class PublishersPolicy < ApplicationPolicy
  def index?
    return false unless subject_user?
    true
  end

  def show?
    return false unless subject_user?
    true
  end

  def create?
    return false unless subject_authenticated_user?
    return true if subject_administrative_authenticated_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:create), object_agent).grant?
  end

  def update?
    return false unless subject_authenticated_user?
    return true if subject_administrative_authenticated_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:update), object_agent).grant?
  end

  def destroy?
    return false unless subject_authenticated_user?
    return true if subject_administrative_authenticated_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:destroy), object_agent).grant?
  end

  def add?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:add), object_agent).grant?
  end

  def remove?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:remove), object_agent).grant?
  end

  def administrator?
    return false unless subject_authenticated_user?
    return true if subject_administrative_authenticated_user?
    PolicyResolver.new(subject_agent, RolePolicyAgent.new(:administrator), object_agent).grant?
  end

  private

    def subject_user?
      subject_agent.client_type == :User.to_s
    end

    def subject_authenticated_user?
      return false unless subject_user?
      subject_agent.authenticated?
    end

    def subject_administrative_authenticated_user?
      return false unless subject_authenticated_user?
      subject_agent.administrator?
    end
end
