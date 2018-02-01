# frozen_string_literal: true

class UsersPolicy < ApplicationPolicy
  def index?
    case object_agent.client_type
    when :Publisher.to_s
      PublisherUsersPolicy.new([subject_agent, object_agent]).index?
    when :Newspaper.to_s
      NewspaperUsersPolicy.new([subject_agent, object_agent]).index?
    when :User.to_s
      return false unless subject_agent.client_type == :User.to_s
      true
    else
      false
    end
  end

  def show?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    # return true if subject_agent.client == object_agent.client
    # PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:show), object_agent).grant?
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
    return true if subject_agent.client == object_agent.client
    return true if subject_agent.administrator?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:update), object_agent).grant?
  end

  def destroy?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    # return true if subject_agent.client == object_agent.client
    return true if subject_agent.administrator?
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:destroy), object_agent).grant?
  end

  # def join?
  #   return false unless subject_agent.client_type == :User.to_s
  #   return false unless subject_agent.authenticated?
  #   return true if subject_agent.client == object_agent.client
  #   PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:join), object_agent).grant?
  # end

  # def join?(object)
  #   PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object).grant?
  # end

  # def leave?
  #   return false unless subject_agent.client_type == :User.to_s
  #   return false unless subject_agent.authenticated?
  #   return true if subject_agent.client == object_agent.client
  #   PolicyResolver.new(subject_agent, ActionPolicyAgent.new(:leave), object_agent).grant?
  # end

  # def leave?(object)
  #   PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object).grant?
  # end
  #
  # def add?(object)
  #   PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object).grant?
  # end
  #
  # def remove?(object)
  #   PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object).grant?
  # end
  #
  # def administrator?(user)
  #   PolicyResolver.new(user, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
  # end
  #
  # def permit?(_user)
  #   PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
  # end
  #
  # def revoke?(_user)
  #   PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, object_agent).grant?
  # end

  # def administrator?
  #   PolicyResolver.new(object_agent, PolicyMaker::ROLE_ADMINISTRATOR, PolicyMaker::OBJECT_ANY).grant?
  # end
  #
  # def permit?
  #   PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, PolicyMaker::OBJECT_ANY).grant?
  # end
  #
  # def revoke?
  #   PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, PolicyMaker::OBJECT_ANY).grant?
  # end
end
