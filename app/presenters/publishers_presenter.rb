# frozen_string_literal: true

class PublishersPresenter < ApplicationsPresenter
  def initialize(user, policy, publishers)
    presenters = publishers.map do |publisher|
      PublisherPresenter.new(user, PublishersPolicy.new([policy.subject_agent, ObjectPolicyAgent.new(:Publisher, publisher)]), publisher)
    end
    super(user, policy, publishers, presenters)
  end
end
