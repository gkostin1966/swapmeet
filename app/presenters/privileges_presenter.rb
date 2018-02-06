# frozen_string_literal: true

class PrivilegesPresenter < ApplicationsPresenter
  def initialize(user, policy, privileges)
    presenters = privileges.select { |p| p.subject_id == policy.agents[1].client_id }.map do |privilege|
      agents = policy.agents.dup
      agents[-1] = ObjectPolicyAgent.new(:Privilege, privilege)
      PrivilegePresenter.new(user, PrivilegesPolicy.new(agents), privilege)
    end
    super(user, policy, privileges, presenters)
  end
end
