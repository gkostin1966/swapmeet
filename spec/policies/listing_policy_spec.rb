# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListingPolicy, type: :policy do
  it_should_behave_like 'an application policy'

  let(:listing_agent) { ListingPolicyAgent.new(listing) }
  let(:listing) { double('listing') }

  context 'Entity' do
    subject { described_class.new([entity_agent, listing_agent]) }

    let(:entity_agent) { SubjectPolicyAgent.new(:Entity, entity) }
    let(:entity) { double('entity') }

    it do
      expect(subject.index?).to be false
      expect(subject.show?).to be false
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end

    context 'Recursion' do
      let(:agent) { double('agent') }
      let(:policy) { double('policy') }
      let(:boolean) { double('boolean') }

      before do
        allow(ListingPolicyAgent).to receive(:new).with(listing).and_call_original
        allow(ListingPolicyAgent).to receive(:new).with(entity).and_return(agent)
        allow(ListingPolicy).to receive(:new).with(entity_agent, listing_agent).and_call_original
        allow(ListingPolicy).to receive(:new).with(entity_agent, agent).and_return(policy)
      end
    end
  end

  context 'User' do
    subject { described_class.new([user_agent, listing_agent]) }

    let(:user_agent) { SubjectPolicyAgent.new(:User, user) }
    let(:user) { double('user') }

    before do
      allow(user_agent).to receive(:authenticated?).and_return(false)
    end

    it do
      expect(subject.index?).to be true
      expect(subject.show?).to be true
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end

    context 'Authenticated' do
      before do
        allow(user_agent).to receive(:authenticated?).and_return(true)
        allow(listing_agent).to receive(:creator?).with(user).and_return(false)
      end

      it do
        expect(subject.index?).to be true
        expect(subject.show?).to be true
        expect(subject.create?).to be true
        expect(subject.update?).to be false
        expect(subject.destroy?).to be false
      end

      context 'Creator' do
        before { allow(listing_agent).to receive(:creator?).with(user).and_return(true) }
        it do
          expect(subject.index?).to be true
          expect(subject.show?).to be true
          expect(subject.create?).to be true
          expect(subject.update?).to be true
          expect(subject.destroy?).to be true
        end
      end

      context 'Grant' do
        before { PolicyMaker.permit!(PolicyMaker::USER_ANY, PolicyMaker::ACTION_ANY, PolicyMaker::LISTING_ANY) }
        it do
          expect(subject.index?).to be true
          expect(subject.show?).to be true
          expect(subject.create?).to be true
          expect(subject.update?).to be true
          expect(subject.destroy?).to be true
        end
      end
    end
  end
end
