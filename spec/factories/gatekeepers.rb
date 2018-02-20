# frozen_string_literal: true

FactoryBot.define do
  factory :gatekeeper do
    subject_type "Subject"
    subject_id "1"
    verb_type "Verb"
    verb_id "1"
    object_type "Object"
  end
end
