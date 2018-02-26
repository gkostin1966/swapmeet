# frozen_string_literal: true

class Authorization
  attr_reader :user, :action, :target

  def initialize(user, action, target)
    @user = user
    @action = action
    @target = target
  end

  def permit?
    permit_user_action? && permit_user_target? && permit_action_target?
  end

  private

    def permit_user_action?
      false
    end

    def permit_action_target?
      false
    end

    def permit_user_target?
      false
    end
end
