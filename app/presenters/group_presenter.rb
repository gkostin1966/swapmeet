# frozen_string_literal: true

class GroupPresenter < ApplicationPresenter
  attr_reader :groups

  delegate :add?, :remove?, :join?, :leave?, to: :policy

  delegate :name, :display_name, to: :model

  def label
    return model.display_name if model.display_name.present?
    'GROUP'
  end

  def parent?
    model.parent.present?
  end

  def parent
    GroupPresenter.new(user, GroupsPolicy.new([policy.subject_agent, ObjectPolicyAgent.new(:Group, model.parent)]), model.parent)
  end

  def groups
    @groups ||= Group.all.map { |group| [group.display_name, group.id] }
  end

  def child?
    false
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

  def user?
    model.users.exists?(policy.subject_agent.client.id)
  end

  def users?
    !model.users.empty?
  end

  def users
    UsersPresenter.new(user, UsersPolicy.new([policy.subject_agent, policy.object_agent]), model.users)
  end
end
