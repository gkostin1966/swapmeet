# frozen_string_literal: true

class RolePolicyAgent < VerbPolicyAgent
  ROLES = %i[administrator]

  def initialize(client)
    raise VerbRoleError unless ROLES.include?(client) unless client == nil
    super(:Role, client)
  end
end
