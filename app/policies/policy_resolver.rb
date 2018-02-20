# frozen_string_literal: true

class PolicyResolver
  attr_reader :subject_agent
  attr_reader :verb_agent
  attr_reader :object_agent

  def initialize(subject_agent, verb_agent, object_agent)
    @subject_agent = subject_agent
    @verb_agent = verb_agent
    @object_agent = object_agent
  end

  def grant?
    gatekeepers = Gatekeeper
      .where('subject_type is NULL or subject_type = "" or subject_type = ?', subject_agent.client_type)
      .where('subject_id is NULL or subject_id = "" or subject_id = ?', subject_agent.client_id)
      .where('verb_type is NULL or verb_type = "" or verb_type = ?', verb_agent.client_type)
      .where('verb_id is NULL or verb_id = "" or verb_id = ?', verb_agent.client_id)
      .where('object_type is NULL or object_type = "" or object_type = ?', object_agent.client_type)
      .where('object_id is NULL or object_id = "" or object_id = ?', object_agent.client_id)
    gatekeepers.each do |gatekeeper|
      encoding = encode(gatekeeper)
      return true if encoding == 0
      return true if encoding == encoding & (SUBJECT_TYPE              | VERB_TYPE           | OBJECT_TYPE)
      return true if encoding == encoding & (SUBJECT_TYPE              | VERB_TYPE           | OBJECT_TYPE | OBJECT_ID)
      return true if encoding == encoding & (SUBJECT_TYPE              | VERB_TYPE | VERB_ID | OBJECT_TYPE)
      return true if encoding == encoding & (SUBJECT_TYPE              | VERB_TYPE | VERB_ID | OBJECT_TYPE | OBJECT_ID)
      return true if encoding == encoding & (SUBJECT_TYPE | SUBJECT_ID | VERB_TYPE           | OBJECT_TYPE)
      return true if encoding == encoding & (SUBJECT_TYPE | SUBJECT_ID | VERB_TYPE           | OBJECT_TYPE | OBJECT_ID)
      return true if encoding == encoding & (SUBJECT_TYPE | SUBJECT_ID | VERB_TYPE | VERB_ID | OBJECT_TYPE)
      return true if encoding == encoding & (SUBJECT_TYPE | SUBJECT_ID | VERB_TYPE | VERB_ID | OBJECT_TYPE | OBJECT_ID)
    end
    false
  end

  private
    SUBJECT_TYPE = 0b000100000
    SUBJECT_ID   = 0b000010000
    VERB_TYPE    = 0b000001000
    VERB_ID      = 0b000000100
    OBJECT_TYPE  = 0b000000010
    OBJECT_ID    = 0b000000001

    def encode(gatekeeper)
      encoding = 0
      encoding |= OBJECT_ID    if gatekeeper.object_id.present?
      encoding |= OBJECT_TYPE  if gatekeeper.object_type.present?
      encoding |= VERB_ID      if gatekeeper.verb_id.present?
      encoding |= VERB_TYPE    if gatekeeper.verb_type.present?
      encoding |= SUBJECT_ID   if gatekeeper.subject_id.present?
      encoding |= SUBJECT_TYPE if gatekeeper.subject_type.present?
      encoding
    end
end
