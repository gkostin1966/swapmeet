# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubjectPolicyAgent do
  subject { entity_agent }

  let(:entity_agent) { described_class.new(:Entity, entity) }
  let(:entity) { double('entity') }

  it do
    is_expected.to be_a(PolicyAgent)
    expect(subject.client_type).to eq :Entity.to_s
    expect(subject.client_id).to eq "anonymous"
    expect(subject.client).to be entity
  end
end
