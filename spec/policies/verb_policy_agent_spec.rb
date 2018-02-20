# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VerbPolicyAgent do
  subject { entity_agent }

  let(:entity_agent) { described_class.new(:Entity, entity) }
  let(:entity) { nil }

  it { is_expected.to be_a(PolicyAgent) }
  it { expect(subject.client_type).to eq :Entity.to_s }
  it { expect(subject.client_id).to eq entity }
  it { expect(subject.client).to be entity }
end