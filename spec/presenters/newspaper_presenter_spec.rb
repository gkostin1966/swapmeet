# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewspaperPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, model) }
  let(:user) { build(:user) }
  let(:policy) { NewspapersPolicy.new([SubjectPolicyAgent.new(:User, user), NewspaperPolicyAgent.new(model)]) }
  let(:model) { build(:newspaper, display_name: display_name, publisher: publisher, listings: listings, groups: groups, users: users) }
  let(:display_name) { nil }
  let(:publisher) { nil }
  let(:listings) { [] }
  let(:groups) { [] }
  let(:users) { [] }

  it { is_expected.to be_a(described_class) }

  context 'user delegation' do
    before do
    end
    it do
      expect(subject.user).to be user
    end
  end

  context 'policy delegation' do
    before do
    end
    it do
      expect(subject.policy).to be policy
    end
  end

  context 'model delegation' do
    before do
    end
    it do
      expect(subject.model).to be model
      expect(subject.name).to be model.name
      expect(subject.display_name).to be model.display_name
    end
  end

  describe '#label' do
    subject { presenter.label }
    it { is_expected.to be_a(String) }
    context 'blank' do
      let(:display_name) { nil }
      it { is_expected.to eq 'NEWSPAPER' }
    end
    context 'present' do
      let(:display_name) { 'display_name' }
      it { is_expected.to eq model.display_name }
    end
  end

  describe '#newspaper?' do
    subject { presenter.newspaper?(object_presenter) }
    let(:object_presenter) { ApplicationPresenter.new(user, object_policy, object_model) }
    let(:object_policy) { ApplicationPolicy.new([user, ObjectPolicyAgent.new(:Object, object_model)]) }
    let(:object_model) { double('object model', newspapers: object_newspapers) }
    let(:object_newspapers) { double('object newspapers') }
    let(:boolean) { double('boolean') }
    before { allow(object_newspapers).to receive(:exists?).with(policy.object_agent.client.id).and_return(boolean) }
    it { is_expected.to be boolean }
  end

  describe '#add?' do
    subject { presenter.add?(object_presenter) }
    let(:object_presenter) { ApplicationPresenter.new(user, object_policy, object_model) }
    let(:object_policy) { ApplicationPolicy.new([user, ObjectPolicyAgent.new(:Object, object_model)]) }
    let(:object_model) { double('object model') }
    let(:boolean) { double('boolean') }
    before { allow(object_policy).to receive(:add?).with(policy.object_agent).and_return(boolean) }
    it { is_expected.to be boolean }
  end

  describe '#remove?' do
    subject { presenter.remove?(object_presenter) }
    let(:object_presenter) { ApplicationPresenter.new(user, object_policy, object_model) }
    let(:object_policy) { ApplicationPolicy.new([user, ObjectPolicyAgent.new(:Object, object_model)]) }
    let(:object_model) { double('object model') }
    let(:boolean) { double('boolean') }
    before { allow(object_policy).to receive(:remove?).with(policy.object_agent).and_return(boolean) }
    it { is_expected.to be boolean }
  end

  describe '#publisher?' do
    subject { presenter.publisher? }
    context 'blank' do
      let(:publisher) { nil }
      it { is_expected.to be false }
    end
    context 'present' do
      let(:publisher) { build(:publisher) }
      it { is_expected.to be true }
    end
  end

  describe '#publisher' do
    subject { presenter.publisher }
    let(:publisher) { build(:publisher) }
    it do
      is_expected.to be_a(PublisherPresenter)
      expect(subject.user).to be user
      expect(subject.policy).to be_a(PublishersPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be_a(PublisherPolicyAgent)
      expect(subject.policy.object_agent.client_type).to eq :Publisher.to_s
      expect(subject.policy.object_agent.client).to be model.publisher
      expect(subject.model).to be model.publisher
    end
  end

  describe '#publishers' do
    subject { presenter.publishers }
    let(:publishers) do
      [
          build(:publisher, id: 0),
          build(:publisher, id: 1),
          build(:publisher, id: 2)
      ]
    end
    before { allow(Publisher).to receive(:all).and_return(publishers) }
    it do
      is_expected.to be_a(Array)
      expect(subject.count).to be publishers.count
      subject.each.with_index do |publisher, index|
        expect(publisher[0]).to be publishers[index].display_name
        expect(publisher[1]).to be index
      end
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
      expect(subject.user).to be user
      expect(subject.policy).to be_a(ListingPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be policy.object_agent
      expect(subject.count).to eq listings.count
      subject.each.with_index do |listing, index|
        expect(listing).to be_a(ListingPresenter)
        expect(listing.user).to be user
        expect(listing.policy).to be_a(ListingPolicy)
        expect(listing.policy.subject_agent).to be policy.subject_agent
        expect(listing.policy.object_agent).to be_a(ListingPolicyAgent)
        expect(listing.policy.object_agent.client_type).to eq :Listing.to_s
        expect(listing.policy.object_agent.client).to be listings[index]
        expect(listing.model).to be listings[index]
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
      expect(subject.user).to be user
      expect(subject.policy).to be_a(GroupsPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be policy.object_agent
      expect(subject.count).to eq groups.count
      subject.each.with_index do |group, index|
        expect(group).to be_a(GroupPresenter)
        expect(group.user).to be user
        expect(group.policy).to be_a(GroupsPolicy)
        expect(group.policy.subject_agent).to be policy.subject_agent
        expect(group.policy.object_agent).to be_a(GroupPolicyAgent)
        expect(group.policy.object_agent.client_type).to eq :Group.to_s
        expect(group.policy.object_agent.client).to be groups[index]
        expect(group.model).to be groups[index]
      end
    end
  end

  describe '#user?' do
    subject { presenter.user?(usr) }
    let(:user) { build(:user) }
    let(:model) { create(:newspaper, users: users) }
    context 'subject' do
      let(:usr) { nil }
      let(:users) { [] }
      it { is_expected.to be false }
      context 'member' do
        let(:users) { [user] }
        it { is_expected.to be true }
      end
    end
    context 'object' do
      let(:usr) { UserPresenter.new(user, policy, member) }
      let(:member) { build(:user) }
      it { is_expected.to be false }
      context 'member' do
        let(:users) { [member] }
        it { is_expected.to be true }
      end
    end
  end

  # describe '#usr' do
  #   subject { presenter.usr }
  #   let(:usr) { build(:user) }
  #   it do
  #     is_expected.to be_a(UserPresenter)
  #     expect(subject.user).to be usr
  #     expect(subject.policy).to be_a(UsersPolicy)
  #     expect(subject.policy.subject_agent).to be policy.subject_agent
  #     expect(subject.policy.object_agent).to be_a(UserPolicyAgent)
  #     expect(subject.policy.object_agent.client_type).to eq :User.to_s
  #     expect(subject.policy.object_agent.client).to be usr
  #     expect(subject.model).to be usr
  #   end
  # end

  describe '#users?' do
    subject { presenter.users? }
    context 'empty' do
      let(:users) { [] }
      it { is_expected.to be false }
    end
    context '!empty' do
      let(:users) { [build(:user)] }
      it { is_expected.to be true }
    end
  end

  describe '#users' do
    subject { presenter.users }
    let(:users) do
      [
          build(:user),
          build(:user),
          build(:user)
      ]
    end
    it do
      is_expected.to be_a(UsersPresenter)
      expect(subject.user).to be user
      expect(subject.policy).to be_a(UsersPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be policy.object_agent
      expect(subject.count).to eq users.count
      subject.each.with_index do |usr, index|
        expect(usr).to be_a(UserPresenter)
        expect(usr.user).to be user
        expect(usr.policy).to be_a(UsersPolicy)
        expect(usr.policy.subject_agent).to be policy.subject_agent
        expect(usr.policy.object_agent).to be_a(UserPolicyAgent)
        expect(usr.policy.object_agent.client_type).to eq :User.to_s
        expect(usr.policy.object_agent.client).to be users[index]
        expect(usr.model).to be users[index]
      end
    end
  end
end
