# frozen_string_literal: true

class DomainPresenter < ApplicationPresenter
  attr_reader :domains

  delegate :name, :display_name, to: :model

  def label
    return model.display_name if model.display_name.present?
    'DOMAIN'
  end

  def parent?
    model.parent.present?
  end

  def parent
    DomainPresenter.new(user, DomainsPolicy.new([policy.subject_agent, ObjectPolicyAgent.new(:Domain, model.parent)]), model.parent)
  end

  def domains
    @domains ||= Domain.all.map { |domain| [domain.display_name, domain.id] }
  end

  def children?
    !model.children.empty?
  end

  def children
    DomainsPresenter.new(user, DomainsPolicy.new([policy.subject_agent, policy.object_agent]), model.children)
  end

  def publishers?
    !model.publishers.empty?
  end

  def publishers
    PublishersPresenter.new(user, PublishersPolicy.new([policy.subject_agent, policy.object_agent]), model.publishers)
  end
end
