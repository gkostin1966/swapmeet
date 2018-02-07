# frozen_string_literal: true

class ApplicationPolicy < Policy
  def authorize!(action, message = nil)
    raise NotAuthorizedError.new(message) unless subject_user?
    return if subject_administrative_user?
    super
  end

  def subject_user?
    @subject_user ||= subject_agent.client_instance? && subject_agent.client_type == :User.to_s
    @subject_user
  end

  def subject_anonymous_user?
    @subject_anonymous_user ||= subject_user? && subject_agent.client_instance_anonymous?
    @subject_anonymous_user
  end

  def subject_authenticated_user?
    @subject_authenticated_user ||= subject_user? && subject_agent.client_instance_authenticated?
    @subject_authenticated_user
  end

  def subject_identified_user?
    @subject_identified_user ||= subject_user? && subject_agent.client_instance_identified?
    @subject_identified_user
  end

  def subject_administrative_user?
    @subject_administrative_user ||= subject_user? && subject_agent.client_instance_administrative?
    @subject_administrative_user
  end
end
