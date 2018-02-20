# frozen_string_literal: true

class ApplicationPolicy < Policy
  def authorize!(action, message = nil)
    raise NotAuthorizedError.new(message) unless subject_user?
    return if subject_administrative_user?
    super
  end

  def subject_user?
    subject_agent.client_instance? && subject_agent.client_type == :User.to_s
  end

  def subject_anonymous_user?
    subject_user? && subject_agent.client_instance_anonymous?
  end

  def subject_authenticated_user?
    subject_user? && subject_agent.client_instance_authenticated?
  end

  def subject_identified_user?
    subject_user? && subject_agent.client_instance_identified?
  end

  def subject_administrative_user?
    subject_user? && subject_agent.client_instance_administrative?
  end
end
