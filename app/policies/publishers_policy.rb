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

  def new?
    return false unless subject_identified_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:new), object_agent).grant?
  end

  def create?
    return false unless subject_identified_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:create), object_agent).grant?
  end

  def edit?
    return false unless subject_identified_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:edit), object_agent).grant?
  end

  def update?
    return false unless subject_identified_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:update), object_agent).grant?
  end

  def delete?
    return false unless subject_identified_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:delete), object_agent).grant?
  end

  def destroy?
    return false unless subject_identified_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:destroy), object_agent).grant?
  end

  def add?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    return true if subject_administrative_user?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:add), object_agent).grant?
  end

  def remove?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    return true if subject_administrative_user?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:remove), object_agent).grant?
  end

  def join?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    return true if subject_administrative_user?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:join), object_agent).grant?
  end

  def leave?
    return false unless subject_user?
    return false unless subject_authenticated_user?
    return true if subject_administrative_user?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:leave), object_agent).grant?
  end

  def permit?
    return false unless subject_identified_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, PolicyPolicyAgent.new(:permit), object_agent).grant?
  end

  def revoke?
    return false unless subject_identified_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, PolicyPolicyAgent.new(:revoke), object_agent).grant?
  end

  def administrator?
    return false unless subject_identified_user?
    return true if subject_administrative_user?
    PolicyResolver.new(subject_agent, RolePolicyAgent.new(:administrator), object_agent).grant?
  end
end
