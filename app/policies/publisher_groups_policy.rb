# frozen_string_literal: true

class PublisherGroupsPolicy < ApplicationPolicy
  def index?
    return true if subject_agent.administrator?
    return false unless subject_agent.client_type == :User.to_s
    return false unless subject_agent.authenticated?
    return false unless object_agent.client_type == :Publisher.to_s
    return false unless object_agent.client_id.present?
    object_agent.client.users.exists?(subject_agent.client_id)
  end
end
