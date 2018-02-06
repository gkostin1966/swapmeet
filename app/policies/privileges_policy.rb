# frozen_string_literal: true

class PrivilegesPolicy < ApplicationPolicy
  def index?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    # return true if subject_agent.client == object_agent.client
    true
  end

  def permit?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, agents[1]).grant? if agents.count > 3
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, agents[2]).grant? if agents.count > 4
    PolicyResolver.new(subject_agent, PolicyPolicyAgent.new(:permit), object_agent).grant?
  end

  def revoke?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return true if subject_agent.administrator?
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, agents[1]).grant? if agents.count > 3
    return true if PolicyResolver.new(subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, agents[2]).grant? if agents.count > 4
    PolicyResolver.new(subject_agent, PolicyPolicyAgent.new(:revoke), object_agent).grant?
  end
end
