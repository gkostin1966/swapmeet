# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionPolicyAgent do
  subject { action_agent }

  let(:action_agent) { described_class.new(action) }
  let(:action) { nil }

  it { is_expected.to be_a(VerbPolicyAgent) }
  it { expect(subject.client_type).to eq :Action.to_s }
  it { expect(subject.client_id).to eq action }
  it { expect(subject.client).to be action }
end
