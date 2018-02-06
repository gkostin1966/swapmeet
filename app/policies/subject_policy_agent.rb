# frozen_string_literal: true

class SubjectPolicyAgent < PolicyAgent
  SUBJECT_TYPES = %i[Entity User]

  def initialize(client_type, client)
    raise SubjectTypeError unless SUBJECT_TYPES.include?(client_type) unless (client_type == nil && client == nil)
    super(client_type, client)
  end

  def anonymous?
    !authenticated?
  end

  def authenticated?
    return false unless client_type == :User.to_s
    return false unless client.present?
    client.known?
  end

  def administrator?
    PolicyMaker.exists?(self, RolePolicyAgent.new(:administrator), PolicyMaker::OBJECT_ANY)
  end
end
