# frozen_string_literal: true

class NewspaperPresenter < ApplicationPresenter
  # attr_reader :publishers

  # delegate :add?, :remove?, to: :policy

  # def permit?(user)
  #   policy.revoke?(user.policy.object_agent)
  # end
  #
  # def revoke?(user)
  #   policy.revoke?(user.policy.object_agent)
  # end

  delegate :name, :display_name, to: :model

  def label
    return model.display_name if model.display_name.present?
    'NEWSPAPER'
  end

  def newspaper?(object)
    object.model.newspapers.exists?(policy.object_agent.client.id)
  end

  def add?(object)
    object.policy.add?(policy.object_agent)
  end

  def remove?(object)
    object.policy.remove?(policy.object_agent)
  end

  def publisher?
    model.publisher.present?
  end

  def publisher
    PublisherPresenter.new(user, PublishersPolicy.new([policy.subject_agent, PublisherPolicyAgent.new(model.publisher)]), model.publisher)
  end

  def publishers
    @publishers ||= Publisher.all.map { |publisher| [publisher.display_name, publisher.id] }
  end

  def listings?
    !model.listings.empty?
  end

  def listings
    ListingsPresenter.new(user, ListingPolicy.new([policy.subject_agent, policy.object_agent]), model.listings)
  end

  def groups?
    !model.groups.empty?
  end

  def groups
    GroupsPresenter.new(user, GroupsPolicy.new([policy.subject_agent, policy.object_agent]), model.groups)
  end

  def user?(usr = nil)
    # return true if administrator?(usr) if usr.present?
    return model.users.exists?(usr.model.id) if usr.present?
    # return true if PolicyResolver.new(policy.subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, PublisherPolicyAgent.new(model.publisher))
    model.users.exists?(user.id)
  end

  # def usr(usr = nil)
  #   UserPresenter.new(user, UsersPolicy.new(policy.subject_agent, policy.object_agent), usr)
  # end

  def users?
    !model.users.empty?
  end

  def users
    UsersPresenter.new(user, UsersPolicy.new([policy.subject_agent, policy.object_agent]), model.users)
  end
end
