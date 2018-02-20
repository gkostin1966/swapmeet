# frozen_string_literal: true

class ListingPolicy < ResourcePolicy
  def show?
    true
  end

  def create?
    return true if user.root?
    user.known?
  end

  def update?
    return true if user.root?
    user == resource.owner
  end

  def destroy?
    return true if user.root?
    user == resource.owner
  end
end
