# frozen_string_literal: true

class SubjectPolicyAgent < PolicyAgent
  SUBJECT_TYPES = %i[Entity User]

  def initialize(client_type, client)
    raise SubjectTypeError unless SUBJECT_TYPES.include?(client_type) unless (client_type == nil && client == nil)
    super(client_type, client)
  end
end
