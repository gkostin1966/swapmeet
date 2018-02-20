# frozen_string_literal: true

class NewspaperPresenter < ApplicationPresenter
  # attr_reader :publishers

  delegate :add?, :remove?, to: :policy

  delegate :name, :display_name, to: :model

  def label
    return model.display_name if model.display_name.present?
    'NEWSPAPER'
  end

  def newspaper?
    false
  end

  def publisher?
    model.publisher.present?
  end

  def publisher
    PublisherPresenter.new(user, PublishersPolicy.new([policy.subject_agent, ObjectPolicyAgent.new(:Publisher, model.publisher)]), model.publisher)
  end

  def publishers
    @publishers ||= Publisher.all.map { |publisher| [publisher.display_name, publisher.id] }
  end

  def listings?
    !model.listings.empty?
  end

  def listings
    ListingsPresenter.new(user, ListingsPolicy.new([policy.subject_agent, policy.object_agent]), model.listings)
  end

  def groups?
    !model.groups.empty?
  end

  def groups
    GroupsPresenter.new(user, GroupsPolicy.new([policy.subject_agent, policy.object_agent]), model.groups)
  end

  def user?
    false
  end

  def users?
    !model.users.empty?
  end

  def users
    @users_presenter ||= UsersPresenter.new(user, UsersPolicy.new(policy.agents.push(ObjectPolicyAgent.new(:User, nil))), model.users)
  end
end
