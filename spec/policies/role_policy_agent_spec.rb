# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RolePolicyAgent do
  subject { role_agent }

  let(:role_agent) { described_class.new(role) }
  let(:role) { nil }

  it { is_expected.to be_a(VerbPolicyAgent) }
  it { expect(subject.client_type).to eq :Role.to_s }
  it { expect(subject.client_id).to eq role }
  it { expect(subject.client).to be role }
end
