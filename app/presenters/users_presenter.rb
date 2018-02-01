# frozen_string_literal: true

class UsersPresenter < ApplicationsPresenter
  def initialize(user, policy, users)
    presenters = users.map do |usr|
      UserPresenter.new(user, UsersPolicy.new([policy.subject_agent, UserPolicyAgent.new(usr)]), usr)
    end
    super(user, policy, users, presenters)
  end
end
