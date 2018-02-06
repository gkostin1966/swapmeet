# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewspapersPolicy, type: :policy do
  let(:newspaper_agent) { ObjectPolicyAgent.new(:Newspaper, newspaper) }
  let(:newspaper) { double('newspaper') }

  context 'Entity' do
    subject { described_class.new([entity_agent, newspaper_agent]) }

    let(:entity_agent) { SubjectPolicyAgent.new(:Entity, entity) }
    let(:entity) { double('entity') }

    describe '#action?' do
      it do
        expect(subject.index?).to be false
        expect(subject.show?).to be false
        expect(subject.create?).to be false
        expect(subject.update?).to be false
        expect(subject.destroy?).to be false
      end
      it do
        expect(subject.add?).to be false
        expect(subject.remove?).to be false
      end
    end
    describe '#role?' do
      it do
        expect(subject.administrator?).to be false
      end
    end
  end

  context 'User' do
    subject { described_class.new([user_agent, newspaper_agent]) }

    let(:user_agent) { SubjectPolicyAgent.new(:User, user) }
    let(:user) { double('user') }

    before { allow(user_agent).to receive(:authenticated?).and_return(false) }

    describe '#action?' do
      it do
        expect(subject.index?).to be true
        expect(subject.show?).to be true
        expect(subject.create?).to be false
        expect(subject.update?).to be false
        expect(subject.destroy?).to be false
      end
      it do
        expect(subject.add?).to be false
        expect(subject.remove?).to be false
      end
    end
    describe '#role?' do
      it do
        expect(subject.administrator?).to be false
      end
    end

    context 'Authenticated' do
      before { allow(user_agent).to receive(:authenticated?).and_return(true) }
      describe '#action?' do
        it do
          expect(subject.index?).to be true
          expect(subject.show?).to be true
          expect(subject.create?).to be false
          expect(subject.update?).to be false
          expect(subject.destroy?).to be false
        end
        it do
          expect(subject.add?).to be false
          expect(subject.remove?).to be false
        end
      end
      describe '#role?' do
        it do
          expect(subject.administrator?).to be false
        end
      end

      context 'Grant' do
        describe '#action?' do
          before { PolicyMaker.permit!(user_agent, PolicyMaker::ACTION_ANY, PolicyMaker::OBJECT_ANY) }
          it do
            expect(subject.index?).to be true
            expect(subject.show?).to be true
            expect(subject.create?).to be true
            expect(subject.update?).to be true
            expect(subject.destroy?).to be true
          end
          it do
            expect(subject.add?).to be true
            expect(subject.remove?).to be true
          end
        end
        describe '#role?' do
          before { PolicyMaker.permit!(user_agent, PolicyMaker::ROLE_ADMINISTRATOR, newspaper_agent) }
          it do
            expect(subject.administrator?).to be true
          end
        end
      end
    end
  end
end
