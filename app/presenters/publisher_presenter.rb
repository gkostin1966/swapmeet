# frozen_string_literal: true

class PublisherPresenter < ApplicationPresenter
  attr_reader :domains

  delegate :add?, :remove?, to: :policy

  delegate :name, :display_name, to: :model

  def label
    return model.display_name if model.display_name.present?
    'PUBLISHER'
  end

  def domain?
    model.domain.present?
  end

  def domain
    DomainPresenter.new(user, DomainsPolicy.new([policy.subject_agent, ObjectPolicyAgent.new(:Domain, model.domain)]), model.domain)
  end

  def domains
    @domains = Domain.all.map { |domain| [domain.display_name, domain.id] }
  end

  def newspaper?
    false
  end

  def newspapers?
    !model.newspapers.empty?
  end

  def newspapers
    NewspapersPresenter.new(user, NewspapersPolicy.new([policy.subject_agent, policy.object_agent]), model.newspapers)
  end

  def group?
    false
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
