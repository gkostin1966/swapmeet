# frozen_string_literal: true

class ApplicationPolicy
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

  def new?
    create?
  end

  def edit?
    update?
  end

  def authorize!(action, message = nil)
    return if send(action)
    return if PolicyResolver.new(subject_agent, ActionPolicyAgent.new(action.to_s.chop.to_sym), object_agent).grant?
    raise NotAuthorizedError.new(message)
  end

  def respond_to_missing?(method_name, include_private = false)
    return true if method_name[-1] == '?'
    super
  end

  def method_missing(method_name, *args, &block)
    return super if method_name[-1] != '?'
    PolicyResolver.new(subject_agent, ActionPolicyAgent.new(method_name.to_s.chop.to_sym), object_agent).grant?
  end
end
