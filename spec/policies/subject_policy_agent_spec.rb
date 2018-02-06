# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubjectPolicyAgent do
  subject { entity_agent }

  let(:entity_agent) { described_class.new(:Entity, entity) }
  let(:entity) { double('entity') }

  it do
    is_expected.to be_a(PolicyAgent)
    expect(subject.client_type).to eq :Entity.to_s
    expect(subject.client_id).to eq entity.to_s
    expect(subject.client).to be entity
  end

  describe '#anonymous?' do
    it do
      is_expected.to receive(:authenticated?)
      subject.anonymous?
    end

    it { expect(subject.anonymous?).to eq !subject.authenticated? }
  end

  describe '#authenticated?' do
    subject { entity_agent.authenticated? }

    it { is_expected.to be false }

    context 'user' do
      let(:entity_agent) { described_class.new(:User, user) }
      let(:user) { double('user') }

      before { allow(user).to receive(:known?).and_return false }

      it { is_expected.to be false }

      context 'known' do
        before { allow(user).to receive(:known?).and_return(true) }

        it { is_expected.to be true }
      end
    end
  end

  describe '#administrator?' do
    subject { entity_agent.administrator? }

    it { is_expected.to be false }

    context 'administrator' do
      before do
        Gatekeeper.new(
          subject_type: entity_agent.client_type,
          subject_id: entity_agent.client_id,
          verb_type: PolicyMaker::ROLE_ADMINISTRATOR.client_type,
          verb_id: PolicyMaker::ROLE_ADMINISTRATOR.client_id,
          object_type: PolicyMaker::OBJECT_ANY.client_type,
          object_id: PolicyMaker::OBJECT_ANY.client_id
        ).save!
      end

      it { is_expected.to be true }
    end
  end
end
