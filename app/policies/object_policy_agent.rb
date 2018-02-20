# frozen_string_literal: true

class ObjectPolicyAgent < PolicyAgent
  OBJECT_TYPES = %i[Category Domain Entity Gatekeeper Group Listing Newspaper Privilege Publisher User]

  def initialize(client_type, client)
    raise ObjectTypeError unless OBJECT_TYPES.include?(client_type) unless (client_type == nil && client == nil)
    super(client_type, client)
  end
end
