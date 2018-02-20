# frozen_string_literal: true

class CategoryPresenter < ApplicationPresenter
  delegate :name, :display_name, :title, to: :model

  def label
    return model.display_name if model.display_name.present?
    'CATEGORY'
  end

  def listings?
    !model.listings.empty?
  end

  def listings
    ListingsPresenter.new(user, ListingsPolicy.new([policy.subject_agent, policy.object_agent]), model.listings)
  end
end
