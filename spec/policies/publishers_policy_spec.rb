# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublishersPolicy, type: :policy do
  subject { described_class.new([entity_agent, publisher_agent]) }

  let(:entity_agent) { SubjectPolicyAgent.new(entity_type, entity) }
  let(:entity_type) { double('entity_type') }
  let(:entity) { double('entity') }
  let(:publisher_agent) { ObjectPolicyAgent.new(:Publisher, publisher) }
  let(:publisher) { double('publisher') }

  it_should_behave_like 'an application policy'

  context 'Entities except User' do
    SubjectPolicyAgent::SUBJECT_TYPES.each do |entity_type|
      next if %i[User].include?(entity_type)

      let(:entity_type) { entity_type }

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
        context 'Grant' do
          before { PolicyMaker.permit!(entity_agent, PolicyMaker::ACTION_ANY, publisher_agent) }
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
      end

      describe '#role?' do
        it do
          expect(subject.administrator?).to be false
        end
        context 'Grant' do
          before { PolicyMaker.permit!(entity_agent, PolicyMaker::ROLE_ADMINISTRATOR, publisher_agent) }
          it do
            expect(subject.administrator?).to be false
          end
        end
      end
    end
  end

  context 'User' do
    let(:entity_type) { :User }

    before { allow(entity_agent).to receive(:authenticated?).and_return(false) }

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
      context 'Grant' do
        before { PolicyMaker.permit!(entity_agent, PolicyMaker::ACTION_ANY, publisher_agent) }
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
    end

    describe '#role?' do
      it do
        expect(subject.administrator?).to be false
      end
      context 'Grant' do
        before { PolicyMaker.permit!(entity_agent, PolicyMaker::ROLE_ADMINISTRATOR, publisher_agent) }
        it do
          expect(subject.administrator?).to be false
        end
      end
    end

    context 'Authenticated' do
      before { allow(entity_agent).to receive(:authenticated?).and_return(true) }

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
        context 'Grant' do
          before { PolicyMaker.permit!(entity_agent, PolicyMaker::ACTION_ANY, publisher_agent) }
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
      end

      describe '#role?' do
        it do
          expect(subject.administrator?).to be false
        end
        context 'Grant' do
          before { PolicyMaker.permit!(entity_agent, PolicyMaker::ROLE_ADMINISTRATOR, publisher_agent) }
          it do
            expect(subject.administrator?).to be true
          end
        end
      end
    end
  end



  # context 'administrator' do
  #   describe '#administrator?' do
  #     context 'platform administrator' do
  #       before { allow(entity_agent).to receive(:administrator?).and_return(true) }
  #       it { expect(subject.administrator?).to be true }
  #     end
  #     context 'publisher administrator' do
  #       let(:policy_resolver) { double('policy resolver') }
  #       before do
  #         allow(PolicyResolver).to receive(:new).with(entity_agent, PolicyMaker::ROLE_ADMINISTRATOR, publisher_agent).and_return(policy_resolver)
  #         allow(policy_resolver).to receive(:grant?).and_return(true)
  #       end
  #       it { expect(subject.administrator?).to be true }
  #     end
  #   end
  # end
end
