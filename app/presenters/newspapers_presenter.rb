# frozen_string_literal: true

class NewspapersPresenter < ApplicationsPresenter
  def initialize(user, policy, newspapers)
    presenters = newspapers.map do |newspaper|
      NewspaperPresenter.new(user, NewspapersPolicy.new([policy.subject_agent, ObjectPolicyAgent.new(:Newspaper, newspaper)]), newspaper)
    end
    super(user, policy, newspapers, presenters)
  end
end
