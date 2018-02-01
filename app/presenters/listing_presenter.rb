# frozen_string_literal: true

class ListingPresenter < ApplicationPresenter
  attr_reader :categories, :newspapers

  delegate :title, :body, to: :model

  def label
    return model.title if model.title.present?
    'LISTING'
  end

  def category?
    model.category.present?
  end

  def category
    CategoryPresenter.new(user, CategoriesPolicy.new([policy.subject_agent, CategoryPolicyAgent.new(model.category)]), model.category)
  end

  def categories
    @categories ||= Category.all.map { |category| [category.display_name, category.id] }
  end

  def newspaper?
    model.newspaper.present?
  end

  def newspaper
    NewspaperPresenter.new(user, NewspapersPolicy.new([policy.subject_agent, NewspaperPolicyAgent.new(model.newspaper)]), model.newspaper)
  end

  def newspapers
    @newspapers ||= Newspaper.all.map { |newspaper| [newspaper.display_name, newspaper.id] }
  end

  def owner?
    model.owner.present?
  end

  def owner
    UserPresenter.new(user, UsersPolicy.new([policy.subject_agent, UserPolicyAgent.new(model.owner)]), model.owner)
  end
end
