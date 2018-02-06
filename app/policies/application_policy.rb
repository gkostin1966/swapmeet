# frozen_string_literal: true

class ApplicationPolicy < Policy
  def authorize!(action, message = nil)
    return if send(action)
    raise NotAuthorizedError.new(message) unless subject_user?
    return if subject_administrative_authenticated_user?
    super
  end

  def respond_to_missing?(method_name, include_private = false)
    return true if method_name[-1] == '?'
    super
  end

  def method_missing(method_name, *args, &block)
    return super if method_name[-1] != '?'
    false
  end

  private

    def subject_user?
      subject_agent.client_type == :User.to_s
    end

    def subject_authenticated_user?
      return false unless subject_user?
      subject_agent.authenticated?
    end

    def subject_administrative_authenticated_user?
      return false unless subject_authenticated_user?
      subject_agent.administrator?
    end
end
