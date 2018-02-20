# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PolicyAgent do
  let(:entity_agent) { described_class.new(entity_type, entity) }
  let(:entity_type) { double('entity_type') }
  let(:entity) { double('entity') }

  describe '#client' do
    subject { entity_agent.client }
    context 'nil' do
      let(:entity) { nil }
      it { is_expected.to be nil }
    end
    context 'entity' do
      it { is_expected.to be entity }
    end
  end

  describe '#client?' do
    subject { entity_agent.client? }
    context 'nil' do
      let(:entity) { nil }
      it { is_expected.to be false }
    end
    context 'entity' do
      it { is_expected.to be true }
    end
  end

  describe '#client_id' do
    subject { entity_agent.client_id }
    context 'nil' do
      let(:entity) { nil }
      it { is_expected.to be nil }
    end
    context 'entity' do
      it { is_expected.to eq "anonymous" }
      context 'respond_to?(:id)' do
        let(:id) { 1 }
        before { allow(entity).to receive(:id).and_return(id) }
        it { is_expected.to eq id.to_s }
      end
    end
  end

  describe '#client_id?' do
    subject { entity_agent.client_id? }
    context 'nil' do
      let(:entity) { nil }
      it { is_expected.to be false }
    end
    context 'entity' do
      it { is_expected.to be false }
      context 'respond_to?(:id)' do
        let(:id) { 1 }
        before { allow(entity).to receive(:id).and_return(id) }
        it { is_expected.to be true }
      end
    end
  end

  describe "#client_type" do
    subject { entity_agent.client_type }
    context 'nil' do
      let(:entity_type) { nil }
      it { is_expected.to be nil }
    end
    context 'blank' do
      let(:entity_type) { "" }
      it { is_expected.to eq "" }
    end
    context 'present' do
      let(:entity_type) { :Entity }
      it { is_expected.to eq entity_type.to_s }
    end
  end

  describe "#client_type?" do
    subject { entity_agent.client_type? }
    context 'nil' do
      let(:entity_type) { nil }
      it { is_expected.to be false }
    end
    context 'blank' do
      let(:entity_type) { "" }
      it { is_expected.to be false }
    end
    context 'present' do
      let(:entity_type) { :Entity }
      it { is_expected.to be false }
      context 'nil entity' do
        let(:entity)  { nil }
        it { is_expected.to be true }
      end
    end
  end

  context "#client_type?" do
    let(:entity)  { nil }
    it do
      expect(entity_agent.client_type?).to be true
      expect(entity_agent.client_instance?).to be false
      expect(entity_agent.client_instance_authenticated?).to be false
      expect(entity_agent.client_instance_anonymous?).to be false
      expect(entity_agent.client_instance_identified?).to be false
      expect(entity_agent.client_instance_administrative?).to be false
    end
  end

  context '#client_instance?' do
    let(:entity_type) { :User }
    let(:entity) { current_user }

    context '#client_instance_anonymous?' do
      let(:current_user) { User.nobody }
      it do
        expect(entity_agent.client_type?).to be false
        expect(entity_agent.client_instance?).to be true
        expect(entity_agent.client_instance_anonymous?).to be true
        expect(entity_agent.client_instance_authenticated?).to be false
        expect(entity_agent.client_instance_identified?).to be false
        expect(entity_agent.client_instance_administrative?).to be false
      end
    end

    context '#client_instance_authenticated?' do
      let(:current_user) { User.guest }
      it do
        expect(entity_agent.client_type?).to be false
        expect(entity_agent.client_instance?).to be true
        expect(entity_agent.client_instance_anonymous?).to be true
        expect(entity_agent.client_instance_authenticated?).to be true
        expect(entity_agent.client_instance_identified?).to be false
        expect(entity_agent.client_instance_administrative?).to be false
      end
    end

    context '#client_instance_identified?' do
      let(:current_user) { create(:user) }
      it do
        expect(entity_agent.client_type?).to be false
        expect(entity_agent.client_instance?).to be true
        expect(entity_agent.client_instance_anonymous?).to be false
        expect(entity_agent.client_instance_authenticated?).to be true
        expect(entity_agent.client_instance_identified?).to be true
        expect(entity_agent.client_instance_administrative?).to be false
      end
    end

    context '#client_instance_administrative?' do
      let(:current_user) { create(:user) }
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
      it do
        expect(entity_agent.client_type?).to be false
        expect(entity_agent.client_instance?).to be true
        expect(entity_agent.client_instance_anonymous?).to be false
        expect(entity_agent.client_instance_authenticated?).to be true
        expect(entity_agent.client_instance_identified?).to be true
        expect(entity_agent.client_instance_administrative?).to be true
      end
    end
  end
end
