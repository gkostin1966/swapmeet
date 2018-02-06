# frozen_string_literal: true

class ActionPolicyAgent < VerbPolicyAgent
  ACTIONS = %i[index show new create edit update delete destroy add remove join leave]

  def initialize(client)
    raise VerbActionError unless ACTIONS.include?(client) unless client == nil
    super(:Action, client)
  end
end
