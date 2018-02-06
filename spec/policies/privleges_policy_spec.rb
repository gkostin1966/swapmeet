# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrivilegesPolicy, type: :policy do
  it_should_behave_like 'an application policy'

  let(:privilege_agent) { ObjectPolicyAgent.new(:Privilege, privilege) }
  let(:privilege) { double('privilege') }

  context 'Entity' do
    subject { described_class.new([entity_agent, privilege_agent]) }

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
      expect(subject.permit?).to be false
      expect(subject.revoke?).to be false
    end
  end

  context 'User' do
    subject { described_class.new([user_agent, privilege_agent]) }

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
      expect(subject.permit?).to be false
      expect(subject.revoke?).to be false
    end

    context 'Authenticated' do
      before { allow(user_agent).to receive(:authenticated?).and_return(true) }
      it do
        expect(subject.index?).to be true
        expect(subject.show?).to be false
        expect(subject.create?).to be false
        expect(subject.update?).to be false
        expect(subject.destroy?).to be false
      end
      it do
        expect(subject.permit?).to be false
        expect(subject.revoke?).to be false
      end

      context 'Grant' do
        context 'Action' do
          before { PolicyMaker.permit!(PolicyMaker::USER_ANY, PolicyMaker::ACTION_ANY, PolicyMaker::OBJECT_ANY) }
          it do
            expect(subject.index?).to be true
            expect(subject.show?).to be true
            expect(subject.create?).to be true
            expect(subject.update?).to be true
            expect(subject.destroy?).to be true
          end
        end
        context 'Policy' do
          before { PolicyMaker.permit!(PolicyMaker::USER_ANY, PolicyMaker::POLICY_ANY, PolicyMaker::OBJECT_ANY) }
          it do
            expect(subject.permit?).to be true
            expect(subject.revoke?).to be true
          end
        end
      end
    end
  end
end
