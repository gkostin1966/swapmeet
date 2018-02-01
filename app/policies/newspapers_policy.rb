# frozen_string_literal: true

class NewspapersPolicy < ApplicationPolicy
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
    return true if subject_agent.administrator?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:create), object_agent).grant?
  end

  def update?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:update), object_agent).grant?
  end

  def destroy?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:destroy), object_agent).grant?
  end

  def add?(usr = nil)
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:add), object_agent).grant?
  end

  def remove?(usr = nil)
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:remove), object_agent).grant?
  end

  # def add?(usr)
  #   # if usr.present?
  #   return false unless subject_agent.client_type == :User.to_s
  #   return false unless subject_agent.authenticated?
  #   return true if subject_agent.administrator?
  #   return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, PublisherPolicyAgent.new(object_agent.client.publisher)).grant?
  #   return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
  #   PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:add), object_agent).grant?
  #   # else
  #   #   return false unless subject_agent.client_type == :User.to_s
  #   #   return false unless subject_agent.authenticated?
  #   #   return true if subject_agent.administrator?
  #   #   return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, PublisherPolicyAgent.new(object_agent.client.publisher)).grant?
  #   #   return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
  #   #   PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:add), object_agent).grant?
  #   # end
  # end

  # def remove?(usr)
  #   # if usr.present?
  #   return false unless subject_agent.client_type == :User.to_s
  #   return false unless subject_agent.authenticated?
  #   return true if subject_agent.administrator?
  #   return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, PublisherPolicyAgent.new(object_agent.client.publisher)).grant?
  #   return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
  #   PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:remove), object_agent).grant?
  #   # else
  #   #   return false unless subject_agent.client_type == :User.to_s
  #   #   return false unless subject_agent.authenticated?
  #   #   return true if subject_agent.administrator?
  #   #   return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, PublisherPolicyAgent.new(object_agent.client.publisher)).grant?
  #   #   return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
  #   #   PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:remove), object_agent).grant?
  #   # end
  # end

  # def administrator?
  #   return true if subject_agent.administrator?
  #   super
  # end
  #
  # def administrator_user?(user)
  #   PolicyMaker.exist?(user, PolicyMaker::ROLE_ADMINISTRATOR, object_agent)
  # end
  #
  # def permit_user?(user)
  #   PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
  # end
  #
  # def revoke_user?(user)
  #   PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
  # end
end
