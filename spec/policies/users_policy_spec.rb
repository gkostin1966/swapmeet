# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersPolicy, type: :policy do
  it_should_behave_like 'an application policy'

  let(:user_agent) { ObjectPolicyAgent.new(:User, user) }
  let(:user) { double('user') }

  context 'Entity' do
    subject { described_class.new([entity_agent, user_agent]) }

    let(:entity_agent) { SubjectPolicyAgent.new(:Entity, entity) }
    let(:entity) { double('entity') }

    it do
      expect(subject.index?).to be false
      expect(subject.show?).to be false
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
    end

    context 'Objects expect User' do
      let(:policy) { double('policy') }
      let(:boolean) { double('boolean') }
      before do
        allow(user_agent).to receive(:client_type).and_return(client_type)
        allow(policy).to receive(:index?).and_return(boolean)
        allow(policy).to receive(:show?).and_return(boolean)
        allow(policy).to receive(:create?).and_return(boolean)
        allow(policy).to receive(:update?).and_return(boolean)
        allow(policy).to receive(:destroy?).and_return(boolean)
      end

      context 'Publisher' do
        let(:client_type) { :Publisher.to_s }
        before { allow(UsersPolicy).to receive(:new).with([entity_agent, user_agent]).and_return(policy) }
        it do
          expect(subject.index?).to be boolean
          expect(subject.show?).to be boolean
          expect(subject.create?).to be boolean
          expect(subject.update?).to be boolean
          expect(subject.destroy?).to be boolean
        end
      end

      context 'Newspaper' do
        let(:client_type) { :Newspaper.to_s }
        before { allow(UsersPolicy).to receive(:new).with([entity_agent, user_agent]).and_return(policy) }
        it do
          expect(subject.index?).to be boolean
          expect(subject.show?).to be boolean
          expect(subject.create?).to be boolean
          expect(subject.update?).to be boolean
          expect(subject.destroy?).to be boolean
        end
      end
      context 'Entity' do
        let(:client_type) { :Entity.to_s }
        it do
          expect(subject.index?).to be false
          expect(subject.show?).to be false
          expect(subject.create?).to be false
          expect(subject.update?).to be false
          expect(subject.destroy?).to be false
        end
      end
    end
  end


  context 'User' do
    subject { described_class.new([current_user_agent, user_agent]) }

    let(:current_user_agent) { SubjectPolicyAgent.new(:User, current_user) }
    let(:current_user) { double('current user') }

    before { allow(current_user_agent).to receive(:authenticated?).and_return(false) }
    it do
      expect(subject.index?).to be true
      expect(subject.show?).to be false
      expect(subject.create?).to be false
      expect(subject.update?).to be false
      expect(subject.destroy?).to be false
      expect(subject.add?).to be false
      expect(subject.remove?).to be false
    end

    context 'Authenticated' do
      before { allow(current_user_agent).to receive(:authenticated?).and_return(true) }
      it do
        expect(subject.index?).to be true
        expect(subject.show?).to be true
        expect(subject.create?).to be false
        expect(subject.update?).to be false
        expect(subject.destroy?).to be false
        expect(subject.add?).to be false
        expect(subject.remove?).to be false
      end

      context 'Grant' do
        before { PolicyMaker.permit!(PolicyMaker::USER_ANY, PolicyMaker::ACTION_ANY, PolicyMaker::OBJECT_ANY) }
        it do
          expect(subject.index?).to be true
          expect(subject.show?).to be true
          expect(subject.create?).to be true
          expect(subject.update?).to be true
          expect(subject.destroy?).to be true
          expect(subject.add?).to be false
          expect(subject.remove?).to be false
        end
      end

      context 'Administrator' do
        context 'Subject' do
          before { allow(current_user_agent).to receive(:administrator?).and_return(true) }
          it do
            expect(subject.index?).to be true
            expect(subject.show?).to be true
            expect(subject.add?).to be false
            expect(subject.remove?).to be false
          end
        end
        context 'Object' do
          context 'three agents' do
            subject { described_class.new([current_user_agent, user_agent, user_agent]) }
            it do
              expect(subject.index?).to be false
              expect(subject.show?).to be false
              expect(subject.add?).to be false
              expect(subject.remove?).to be false
            end
          end
          context 'four agents' do
            subject { described_class.new([current_user_agent, user_agent, user_agent, user_agent]) }
            it do
              expect(subject.index?).to be false
              expect(subject.show?).to be false
              expect(subject.add?).to be true
              expect(subject.remove?).to be true
            end
          end
        end
      end
    end
  end
end
