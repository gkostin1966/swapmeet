# frozen_string_literal: true

class GroupPresenter < ApplicationPresenter
  attr_reader :groups

  delegate :join?, :leave?, to: :policy

  delegate :name, :display_name, to: :model

  def label
    return model.display_name if model.display_name.present?
    'GROUP'
  end

  def parent?
    model.parent.present?
  end

  def parent
    GroupPresenter.new(user, GroupsPolicy.new([policy.subject_agent, GroupPolicyAgent.new(model.parent)]), model.parent)
  end

  def groups
    @groups ||= Group.all.map { |group| [group.display_name, group.id] }
  end

  def child?(object)
    object.model.groups.exists?(policy.object_agent.client.id)
  end

  def add?(object)
    object.policy.add?(policy.object_agent)
  end

  def remove?(object)
    object.policy.remove?(policy.object_agent)
  end

  def children?
    !model.children.empty?
  end

  def children
    GroupsPresenter.new(user, GroupsPolicy.new([policy.subject_agent, policy.object_agent]), model.children)
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

  def user?(usr = nil)
    return model.users.exists?(usr.model.id) if usr.present?
    model.users.exists?(user.id)
  end

  def users?
    !model.users.empty?
  end

  def users
    UsersPresenter.new(user, UsersPolicy.new([policy.subject_agent, policy.object_agent]), model.users)
  end
end
