# frozen_string_literal: true

class GroupsPolicy < ApplicationPolicy
  def index?
    return false unless @subject.client_type == :User.to_s
    return false unless @subject.authenticated?
    true
  end

  def show?
    return false unless @subject.client_type == :User.to_s
    return false unless @subject.authenticated?
    true
  end

  def create?
    return false unless @subject.client_type == :User.to_s
    return false unless @subject.authenticated?
    return true if @subject.administrator?
    PolicyResolver.new(@subject, ActionPolicyAgent.new(:create), @object).grant?
  end

  def update?
    return false unless @subject.client_type == :User.to_s
    return false unless @subject.authenticated?
    return true if @subject.administrator?
    return true if PolicyResolver.new(@subject, PolicyMaker::ROLE_ADMINISTRATOR, @object).grant?
    PolicyResolver.new(@subject, ActionPolicyAgent.new(:update), @object).grant?
  end

  def destroy?
    return false unless @subject.client_type == :User.to_s
    return false unless @subject.authenticated?
    return true if @subject.administrator?
    PolicyResolver.new(@subject, ActionPolicyAgent.new(:destroy), @object).grant?
  end

  # def add?
  #   return false unless @subject.client_type == :User.to_s
  #   return false unless @subject.authenticated?
  #   return true if @subject.administrator?
  #   PolicyResolver.new(@subject, ActionPolicyAgent.new(:update), @object).grant?
  # end
  #
  # def remove?
  #   return false unless @subject.client_type == :User.to_s
  #   return false unless @subject.authenticated?
  #   return true if @subject.administrator?
  #   PolicyResolver.new(@subject, ActionPolicyAgent.new(:update), @object).grant?
  # end
end
