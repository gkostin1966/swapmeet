# frozen_string_literal: true

class PublisherPresenter < ApplicationPresenter
  attr_reader :domains

  delegate :add?, :remove?, to: :policy

  # def permit?(user)
  #   policy.permit_user?(user.policy.object_agent)
  # end
  #
  # def revoke?(user)
  #   policy.revoke_user?(user.policy.object_agent)
  # end

  delegate :name, :display_name, to: :model

  def label
    return model.display_name if model.display_name.present?
    'PUBLISHER'
  end

  def domain?
    model.domain.present?
  end

  def domain
    DomainPresenter.new(user, DomainsPolicy.new([policy.subject_agent, DomainPolicyAgent.new(model.domain)]), model.domain)
  end

  def domains
    @domains = Domain.all.map { |domain| [domain.display_name, domain.id] }
  end

  def newspaper?(newspaper)
    return model.newspapers.exists?(newspaper.model.id) if newspaper.present?
    false
  end

  def newspapers?
    !model.newspapers.empty?
  end

  def newspapers
    NewspapersPresenter.new(user, NewspapersPolicy.new([policy.subject_agent, policy.object_agent]), model.newspapers)
  end

  def group?(group)
    return model.groups.exists?(group.model.id) if group.present?
    false
  end

  def groups?
    !model.groups.empty?
  end

  def groups
    GroupsPresenter.new(user, GroupsPolicy.new([policy.subject_agent, policy.object_agent]), model.groups)
  end

  def user?(usr = nil)
    return model.users.exists?(usr.model.id) if usr.present?
    false
  end

  def users?
    !model.users.empty?
  end

  def users
    UsersPresenter.new(user, UsersPolicy.new([policy.subject_agent, policy.object_agent]), model.users)
  end
end
