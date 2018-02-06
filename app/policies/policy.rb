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

  def authorize!(action, message = nil)
    return if send(action)
    key = action.to_s.chop.to_sym
    verb_agent =
        if ActionPolicyAgent::ACTIONS.include?(key)
          ActionPolicyAgent.new(key)
        elsif PolicyPolicyAgent::POLICIES.include?(key)
          PolicyPolicyAgent.new(key)
        elsif RolePolicyAgent::ROLES.include?(key)
          RolePolicyAgent.new(key)
        else
          VerbPolicyAgent.new(:Entity, key)
        end
    return if PolicyResolver.new(subject_agent, verb_agent, object_agent).grant?
    raise NotAuthorizedError.new(message)
  end

  def respond_to_missing?(method_name, include_private = false)
    return true if method_name[-1] == '?'
    super
  end

  def method_missing(method_name, *args, &block)
    return super if method_name[-1] != '?'
    key = method_name.to_s.chop.to_sym
    verb_agent =
        if ActionPolicyAgent::ACTIONS.include?(key)
          ActionPolicyAgent.new(key)
        elsif PolicyPolicyAgent::POLICIES.include?(key)
          PolicyPolicyAgent.new(key)
        elsif RolePolicyAgent::ROLES.include?(key)
          RolePolicyAgent.new(key)
        else
          VerbPolicyAgent.new(:Entity, key)
        end
    PolicyResolver.new(subject_agent, verb_agent, object_agent).grant?
  end
end
