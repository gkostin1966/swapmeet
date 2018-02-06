# frozen_string_literal: true

class UsersPresenter < ApplicationsPresenter
  delegate :add?, :remove?, to: :policy

  def initialize(user, policy, users)
    agents = policy.agents
    presenters = users.map do |usr|
      agents_dup = agents.dup
      agents_dup[-1] = ObjectPolicyAgent.new(:User, usr)
      UserPresenter.new(user, UsersPolicy.new(agents_dup), usr)
    end
    super(user, policy, users, presenters)
  end
end
