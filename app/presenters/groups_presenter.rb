# frozen_string_literal: true

class GroupsPresenter < ApplicationsPresenter
  def initialize(user, policy, groups)
    presenters = groups.map do |group|
      GroupPresenter.new(user, GroupsPolicy.new([policy.subject_agent, ObjectPolicyAgent.new(:Group, group)]), group)
    end
    super(user, policy, groups, presenters)
  end
end
