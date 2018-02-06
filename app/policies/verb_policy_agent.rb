# frozen_string_literal: true

class VerbPolicyAgent < PolicyAgent
  VERB_TYPES = %i[Action Entity Policy Role]

  def initialize(client_type, client)
    raise VerbTypeError unless VERB_TYPES.include?(client_type) unless (client_type == nil && client == nil)
    super(client_type, client)
  end
end
