# frozen_string_literal: true

class ListingsPresenter < ApplicationsPresenter
  delegate :add?, :remove?, to: :policy

  def initialize(user, policy, listings)
    presenters = listings.map do |listing|
      ListingPresenter.new(user, ListingsPolicy.new([policy.subject_agent, ObjectPolicyAgent.new(:Listing, listing)]), listing)
    end
    super(user, policy, listings, presenters)
  end
end
