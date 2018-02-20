# frozen_string_literal: true

class DomainsPresenter < ApplicationsPresenter
  def initialize(user, policy, domains)
    presenters = domains.map do |domain|
      DomainPresenter.new(user, DomainsPolicy.new([policy.subject_agent, ObjectPolicyAgent.new(:Domain, domain)]), domain)
    end
    super(user, policy, domains, presenters)
  end
end
