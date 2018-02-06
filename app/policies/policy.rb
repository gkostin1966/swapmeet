# frozen_string_literal: true

class Policy
  attr_reader :agents

  def initialize(agents)
    @agents = agents
  end

  def subject_agent
    @agents.first
  end

  def object_agent
    @agents.last
  end

  def authorize!(verb, message = nil)
    return if send(verb)
    raise NotAuthorizedError.new(message)
  end

  def respond_to_missing?(method_name, include_private = false)
    return super if method_name[-1] != '?'
    method = method_name[0..-2].to_sym
    return true if ActionPolicyAgent::ACTIONS.include?(method)
    return true if PolicyPolicyAgent::POLICIES.include?(method)
    return true if RolePolicyAgent::ROLES.include?(method)
    super
  end

  def method_missing(method_name, *args, &block)
    return super if method_name[-1] != '?'
    method = method_name[0..-2].to_sym
    return false if ActionPolicyAgent::ACTIONS.include?(method)
    return false if PolicyPolicyAgent::POLICIES.include?(method)
    return false if RolePolicyAgent::ROLES.include?(method)
    super
  end
end
