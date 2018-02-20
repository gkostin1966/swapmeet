# frozen_string_literal: true

class ResourcePolicy
  attr_reader :user, :resource

  def initialize(user, resource)
    @user     = user
    @resource = resource
  end

  def show?
    return true if user.root?
    false
  end

  def create?
    return true if user.root?
    false
  end

  def update?
    return true if user.root?
    false
  end

  def destroy?
    return true if user.root?
    false
  end

  def edit?
    update?
  end

  def authorize!(action, message = nil)
    raise NotAuthorizedError.new(message) unless send(action)
  end
end
