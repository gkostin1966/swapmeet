# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublisherUserPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(current_user, policy, model) }
  let(:policy) { PublisherUsersPolicy.new([current_user_agent, publisher_agent, user_agent]) }
  let(:current_user_agent) { SubjectPolicyAgent.new(:User, current_user) }
  let(:current_user) { build(:user) }
  let(:publisher_agent) { PublisherPolicyAgent.new(publisher) }
  let(:publisher) { build(:publisher) }
  let(:user_agent) { UserPolicyAgent.new(model) }
  let(:model) { build(:user, display_name: display_name, listings: listings, newspapers: newspapers, publishers: publishers, groups: groups) }
  let(:display_name) { nil }
  let(:listings) { [] }
  let(:publishers) { [] }
  let(:newspapers) { [] }
  let(:groups) { [] }

  it { is_expected.to be_a(described_class) }

  context 'user delegation' do
    before do
    end
    it do
      expect(subject.user).to be current_user
    end
  end

  context 'policy delegation' do
    before do
    end
    it do
      expect(subject.policy).to be policy
      expect(subject.policy.subject_agent).to be current_user_agent
      expect(subject.policy.publisher_agent).to be publisher_agent
      expect(subject.policy.object_agent).to be user_agent
    end
  end

  context 'model delegation' do
    before do
    end
    it do
      expect(subject.model).to be model
      expect(subject.username).to be model.username
      expect(subject.email).to be model.email
    end
  end

  describe '#label' do
    subject { presenter.label }
    it { is_expected.to be_a(String) }
    context 'blank' do
      let(:display_name) { nil }
      it { is_expected.to eq 'USER' }
    end
    context 'present' do
      let(:display_name) { 'display_name' }
      it { is_expected.to eq model.display_name }
    end
  end

  describe '#listings?' do
    subject { presenter.listings? }
    context 'empty' do
      let(:listings) { [] }
      it { is_expected.to be false }
    end
    context '!empty' do
      let(:listings) { [build(:listing)] }
      it { is_expected.to be true }
    end
  end

  describe '#listings' do
    subject { presenter.listings }
    let(:listings) do
      [
          build(:listing),
          build(:listing),
          build(:listing)
      ]
    end
    it do
      is_expected.to be_a(ListingsPresenter)
      expect(subject.user).to be current_user
      expect(subject.policy).to be_a(ListingPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be policy.object_agent
      expect(subject.count).to eq listings.count
      subject.each.with_index do |listing, index|
        expect(listing).to be_a(ListingPresenter)
        expect(listing.user).to be current_user
        expect(listing.policy).to be_a(ListingPolicy)
        expect(listing.policy.subject_agent).to be policy.subject_agent
        expect(listing.policy.object_agent).to be_a(ListingPolicyAgent)
        expect(listing.policy.object_agent.client_type).to eq :Listing.to_s
        expect(listing.policy.object_agent.client).to be listings[index]
        expect(listing.model).to be listings[index]
      end
    end
  end

  describe '#publishers?' do
    subject { presenter.publishers? }
    context 'empty' do
      let(:publishers) { [] }
      it { is_expected.to be false }
    end
    context '!empty' do
      let(:publishers) { [build(:publisher)] }
      it { is_expected.to be true }
    end
  end

  describe '#publishers' do
    subject { presenter.publishers }
    let(:publishers) do
      [
          build(:publisher),
          build(:publisher),
          build(:publisher)
      ]
    end
    it do
      is_expected.to be_a(PublishersPresenter)
      expect(subject.user).to be current_user
      expect(subject.policy).to be_a(PublishersPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be policy.object_agent
      expect(subject.count).to eq publishers.count
      subject.each.with_index do |publisher, index|
        expect(publisher).to be_a(PublisherPresenter)
        expect(publisher.user).to be current_user
        expect(publisher.policy).to be_a(PublishersPolicy)
        expect(publisher.policy.subject_agent).to be policy.subject_agent
        expect(publisher.policy.object_agent).to be_a(PublisherPolicyAgent)
        expect(publisher.policy.object_agent.client_type).to eq :Publisher.to_s
        expect(publisher.policy.object_agent.client).to be publishers[index]
        expect(publisher.model).to be publishers[index]
      end
    end
  end

  describe '#newspapers?' do
    subject { presenter.newspapers? }
    context 'empty' do
      let(:newspapers) { [] }
      it { is_expected.to be false }
    end
    context '!empty' do
      let(:newspapers) { [build(:newspaper)] }
      it { is_expected.to be true }
    end
  end

  describe '#newspapers' do
    subject { presenter.newspapers }
    let(:newspapers) do
      [
          build(:newspaper),
          build(:newspaper),
          build(:newspaper)
      ]
    end
    it do
      is_expected.to be_a(NewspapersPresenter)
      expect(subject.user).to be current_user
      expect(subject.policy).to be_a(NewspapersPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be policy.object_agent
      expect(subject.count).to eq newspapers.count
      subject.each.with_index do |newspaper, index|
        expect(newspaper).to be_a(NewspaperPresenter)
        expect(newspaper.user).to be current_user
        expect(newspaper.policy).to be_a(NewspapersPolicy)
        expect(newspaper.policy.subject_agent).to be policy.subject_agent
        expect(newspaper.policy.object_agent).to be_a(NewspaperPolicyAgent)
        expect(newspaper.policy.object_agent.client_type).to eq :Newspaper.to_s
        expect(newspaper.policy.object_agent.client).to be newspapers[index]
        expect(newspaper.model).to be newspapers[index]
      end
    end
  end

  describe '#groups?' do
    subject { presenter.groups? }
    context 'empty' do
      let(:groups) { [] }
      it { is_expected.to be false }
    end
    context '!empty' do
      let(:groups) { [build(:group)] }
      it { is_expected.to be true }
    end
  end

  describe '#groups' do
    subject { presenter.groups }
    let(:groups) do
      [
          build(:group),
          build(:group),
          build(:group)
      ]
    end
    it do
      is_expected.to be_a(GroupsPresenter)
      expect(subject.user).to be current_user
      expect(subject.policy).to be_a(GroupsPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be policy.object_agent
      expect(subject.count).to eq groups.count
      subject.each.with_index do |group, index|
        expect(group).to be_a(GroupPresenter)
        expect(group.user).to be current_user
        expect(group.policy).to be_a(GroupsPolicy)
        expect(group.policy.subject_agent).to be policy.subject_agent
        expect(group.policy.object_agent).to be_a(GroupPolicyAgent)
        expect(group.policy.object_agent.client_type).to eq :Group.to_s
        expect(group.policy.object_agent.client).to be groups[index]
        expect(group.model).to be groups[index]
      end
    end
  end

  describe 'privilege?' do
    subject { presenter.privilege? }
    let(:object_presenter) { ApplicationPresenter.new(current_user, object_policy, object_model) }
    let(:object_policy) { ApplicationPolicy.new([current_user_agent, ObjectPolicyAgent.new(:Object, object_model)]) }
    let(:object_model) { double('object model') }
    it { is_expected.to be false }
    context 'privilege' do
      before { PolicyMaker.permit!(policy.subject_agent, PolicyMaker::ROLE_ADMINISTRATOR, policy.object_agent) }
      it { is_expected.to be false }
    end
  end

  describe 'privilege' do
    subject { presenter.privilege }
    it do
      expect(subject).to be_a(PublisherUserPrivilegePresenter)
      expect(subject.user).to eq current_user
      expect(subject.policy).to be_a(PublisherUserPrivilegesPolicy)
      expect(subject.policy.subject_agent).to eq policy.subject_agent
      expect(subject.policy.object_agent).not_to eq policy.object_agent
      expect(subject.model).to eq model
    end
  end

  describe '#user?' do
    subject { presenter.user? }
    let(:object_presenter) { ApplicationPresenter.new(current_user, object_policy, object_model) }
    let(:object_policy) { ApplicationPolicy.new([current_user_agent, ObjectPolicyAgent.new(:Object, object_model)]) }
    let(:object_model) { double('object model', users: object_users) }
    let(:object_users) { double('object users') }
    let(:boolean) { double('boolean') }
    before { allow(object_users).to receive(:exists?).with(policy.object_agent.client.id).and_return(boolean) }
    it { is_expected.not_to be boolean }
  end

  describe '#add?' do
    subject { presenter.add? }
    let(:object_presenter) { ApplicationPresenter.new(current_user, object_policy, object_model) }
    let(:object_policy) { ApplicationPolicy.new([current_user_agent, ObjectPolicyAgent.new(:Object, object_model)]) }
    let(:object_model) { double('object model') }
    let(:boolean) { double('boolean') }
    before { allow(object_policy).to receive(:add?).with(policy.object_agent).and_return(boolean) }
    it { is_expected.not_to be boolean }
  end

  describe '#remove?' do
    subject { presenter.remove? }
    let(:object_presenter) { ApplicationPresenter.new(current_user, object_policy, object_model) }
    let(:object_policy) { ApplicationPolicy.new([current_user_agent, ObjectPolicyAgent.new(:Object, object_model)]) }
    let(:object_model) { double('object model') }
    let(:boolean) { double('boolean') }
    before { allow(object_policy).to receive(:remove?).with(policy.object_agent).and_return(boolean) }
    it { is_expected.not_to be boolean }
  end
end
