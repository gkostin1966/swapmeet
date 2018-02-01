# frozen_string_literal: true

class UserPresenter < ApplicationPresenter
  delegate :username, :display_name, :email, to: :model

  def label
    return model.display_name if model.display_name.present?
    'USER'
  end

  def listings?
    !model.listings.empty?
  end

  def listings
    ListingsPresenter.new(user, ListingPolicy.new([policy.subject_agent, policy.object_agent]), model.listings)
  end

  def publishers?
    !model.publishers.empty?
  end

  def publishers
    PublishersPresenter.new(user, PublishersPolicy.new([policy.subject_agent, policy.object_agent]), model.publishers)
  end

  def newspapers?
    !model.newspapers.empty?
  end

  def newspapers
    NewspapersPresenter.new(user, NewspapersPolicy.new([policy.subject_agent, policy.object_agent]), model.newspapers)
  end

  def groups?
    !model.groups.empty?
  end

  def groups
    GroupsPresenter.new(user, GroupsPolicy.new([policy.subject_agent, policy.object_agent]), model.groups)
  end

  def privilege?(object = nil)
    if object.present?
      PolicyMaker.exists?(policy.object_agent, PolicyMaker::ROLE_ADMINISTRATOR, object.policy.object_agent)
    else
      PolicyMaker.exists?(policy.object_agent, PolicyMaker::ROLE_ADMINISTRATOR, PolicyMaker::OBJECT_ANY)
    end
  end

  def privilege(object = nil)
    if object.present?
      PrivilegePresenter.new(user, PrivilegesPolicy.new([policy.subject_agent, object.policy.object_agent]), object.model)
    else
      PrivilegePresenter.new(user, PrivilegesPolicy.new([policy.subject_agent, policy.object_agent]), model)
    end
  end

  def user?(object)
    object.model.users.exists?(policy.object_agent.client.id)
  end

  def add?(object)
    object.policy.add?(policy.object_agent)
  end

  def remove?(object)
    object.policy.remove?(policy.object_agent)
  end
end
