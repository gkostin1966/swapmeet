# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authorization, type: :authorization do
  subject { authorization }

  let(:authorization) { described_class.new }

  it { is_expected.not_to be_nil }

  describe '#authority_for' do
    subject { authorization.authority_for(user, action, target) }

    let(:user) { double("user") }
    let(:username) { double("username") }
    let(:action) { double("action") }
    let(:target) { double("target") }

    before do
      allow(user).to receive(:username).and_return("username")
      allow(action).to receive(:to_sym).and_return(:action)
      allow(target).to receive(:entity_type).and_return("Entity")
      allow(target).to receive(:id).and_return("id")
    end

    it do
      is_expected.to be_a(Checkpoint::Authority)
      expect(subject.any?).to be false
    end

    context 'any is false' do
      let(:repository) { double("repository") }
      before do
        allow(repository).to receive(:permits_for).with(["user:username", "account-type:guest"], ["permission:action"], ["Entity:id", "type:Entity"]).and_return([])
      end
      it do
        subject.repository = repository
        expect(subject.any?).to be false
      end
    end

    context 'any is true' do
      let(:repository) { double("repository") }
      before do
        allow(repository).to receive(:permits_for).with(["user:username", "account-type:guest"], ["permission:action"], ["Entity:id", "type:Entity"]).and_return([true])
      end
      it do
        subject.repository = repository
        expect(subject.any?).to be true
      end
    end
  end

  # describe '#agent_for' do
  #   subject { authorization.agent_for(entity) }
  #
  #   let(:entity) { double('entity') }
  #   let(:entity_id) { double('entity id') }
  #
  #   before do
  #     allow(entity).to receive(:id).and_return(entity_id)
  #   end
  #
  #   it do
  #     is_expected.to be_a(Checkpoint::Agent)
  #     expect(subject.type).to be entity.class
  #     expect(subject.id).to be entity.id
  #     expect(subject.token).to eq "#{entity.class}:#{entity.id}"
  #     expect(subject.uri).to eq "agent://#{entity.class}/#{entity.id}"
  #     expect(subject.to_s).to eq subject.token
  #   end
  # end
  #
  # describe '#resource_for' do
  #   subject { authorization.resource_for(entity) }
  #
  #   let(:entity) { double('entity') }
  #   let(:entity_id) { double('entity id') }
  #
  #   before do
  #     allow(entity).to receive(:id).and_return(entity_id)
  #   end
  #
  #   it do
  #     is_expected.to be_a(Checkpoint::Resource)
  #     expect(subject.token).to eq "#{entity.class}:#{entity.id}"
  #     expect(subject.to_s).to eq "resource://#{subject.token}"
  #   end
  # end
end
