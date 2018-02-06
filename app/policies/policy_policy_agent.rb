# frozen_string_literal: true

class PolicyPolicyAgent < VerbPolicyAgent
  POLICIES = %i[permit revoke]

  def initialize(client)
    raise VerbPolicyError unless POLICIES.include?(client) unless client == nil
    super(:Policy, client)
  end
end
