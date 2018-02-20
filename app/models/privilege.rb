# frozen_string_literal: true

class Privilege
  include ActiveModel::Model
  attr_accessor :id
  attr_accessor :requestor
  attr_accessor :subject_type
  attr_accessor :subject_id
  attr_accessor :verb_type
  attr_accessor :verb_id
  attr_accessor :object_type
  attr_accessor :object_id

  def self.all
    privileges = []
    Gatekeeper.all.each_with_index do |gatekeeper, index|
      privileges << Privilege.new(
        id: gatekeeper.id,
        subject_type: gatekeeper.subject_type,
        subject_id: gatekeeper.subject_id,
        verb_type: gatekeeper.verb_type,
        verb_id: gatekeeper.verb_id,
        object_type: gatekeeper.object_type,
        object_id: gatekeeper.object_id
      )
    end
    privileges
  end
end
