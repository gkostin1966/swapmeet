# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublisherNewspapersPolicy, type: :policy do
  it_should_behave_like 'an application policy'

  let(:newspaper_agent) { NewspaperPolicyAgent.new(newspaper) }
  let(:newspaper) { double('newspaper') }

  context 'Entity' do
    subject { described_class.new([entity_agent, newspaper_agent]) }

    let(:entity_agent) { SubjectPolicyAgent.new(:Entity, entity) }
    let(:entity) { double('entity') }

    it do
      expect(subject.index?).to be false
      expect(subject.show?).to be false
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end

    it do
      expect(subject.administrator?).to be false
      expect(subject.privilege?).to be false
    end
  end

  context 'User' do
    subject { described_class.new([user_agent, newspaper_agent]) }

    let(:user_agent) { SubjectPolicyAgent.new(:User, user) }
    let(:user) { double('user') }

    before { allow(user_agent).to receive(:authenticated?).and_return(false) }
    it do
      expect(subject.index?).to be false
      expect(subject.show?).to be false
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end

    it do
      expect(subject.administrator?).to be false
      expect(subject.privilege?).to be false
    end

    context 'Authenticated' do
      before { allow(user_agent).to receive(:authenticated?).and_return(true) }
      it do
        expect(subject.index?).to be false
        expect(subject.show?).to be false
        expect(subject.create?).to be false
        expect(subject.update?).to be false
        expect(subject.destroy?).to be false
      end

      it do
        expect(subject.administrator?).to be false
        expect(subject.privilege?).to be false
      end

      context 'Grant' do
        context 'action' do
          before { PolicyMaker.permit!(PolicyMaker::USER_ANY, PolicyMaker::ACTION_ANY, PolicyMaker::OBJECT_ANY) }
          it do
            expect(subject.index?).to be false
            expect(subject.show?).to be true
            expect(subject.create?).to be true
            expect(subject.update?).to be true
            expect(subject.destroy?).to be true
          end
        end

        # describe '#administrator?' do
        #   context 'platform administrator' do
        #     before { allow(user_agent).to receive(:administrator?).and_return(true) }
        #     it { expect(subject.administrator?).to be false }
        #   end
        #   context 'publisher administrator' do
        #     let(:publisher_agent) { PublisherPolicyAgent.new(publisher) }
        #     let(:publisher) { double('publisher') }
        #     let(:policy_resolver) { double('policy resolver') }
        #     before do
        #       allow(PolicyResolver).to receive(:new).and_call_original
        #       allow(PolicyResolver).to receive(:new).with(user_agent, PolicyMaker::ROLE_ADMINISTRATOR, publisher_agent).and_return(policy_resolver)
        #       allow(policy_resolver).to receive(:grant?).and_return(true)
        #     end
        #     xit { expect(subject.administrator?).to be true }
        #   end
        #   context 'newspaper administrator' do
        #     let(:policy_resolver) { double('policy resolver') }
        #     before do
        #       allow(PolicyResolver).to receive(:new).with(user_agent, PolicyMaker::ROLE_ADMINISTRATOR, newspaper_agent).and_return(policy_resolver)
        #       allow(policy_resolver).to receive(:grant?).and_return(true)
        #     end
        #     it { expect(subject.administrator?).to be true }
        #   end
        # end
      end

      context 'Publisher Agent' do
        subject { described_class.new([user_agent, publisher_agent]) }
        let(:publisher_agent) { PublisherPolicyAgent.new(publisher_object) }
        let(:publisher_object) { nil }
        it { expect(subject.index?).to be false }
        context 'Publisher Object' do
          let(:publisher_object) { create(:publisher, users: publisher_users) }
          let(:publisher_users) { [] }
          it { expect(subject.index?).to be false }
          context 'Publisher Object User' do
            let(:publisher_users) { [user] }
            let(:user) { create(:user) }
            it { expect(subject.index?).to be true }
          end
        end
      end
    end
  end
end
