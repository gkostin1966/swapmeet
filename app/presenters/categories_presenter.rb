# frozen_string_literal: true

class CategoriesPresenter < ApplicationsPresenter
  def initialize(user, policy, categories)
    presenters = categories.map do |category|
      CategoryPresenter.new(user, CategoriesPolicy.new([policy.subject_agent, ObjectPolicyAgent.new(:Category, category)]), category)
    end
    super(user, policy, categories, presenters)
  end
end
