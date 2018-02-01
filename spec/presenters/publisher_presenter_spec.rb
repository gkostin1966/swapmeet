# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublisherPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, model) }
  let(:user) { build(:user) }
  let(:policy) { PublishersPolicy.new([SubjectPolicyAgent.new(:User, user), PublisherPolicyAgent.new(model)]) }
  let(:model) { build(:publisher, display_name: display_name, domain: domain, newspapers: newspapers, groups: groups, users: users) }
  let(:display_name) { nil }
  let(:domain) { nil }
  let(:newspapers) { [] }
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
      it { is_expected.to eq 'PUBLISHER' }
    end
    context 'present' do
      let(:display_name) { 'display_name' }
      it { is_expected.to eq model.display_name }
    end
  end

  describe '#domain?' do
    subject { presenter.domain? }
    context 'blank' do
      let(:domain) { nil }
      it { is_expected.to be false }
    end
    context 'present' do
      let(:domain) { build(:domain) }
      it { is_expected.to be true }
    end
  end

  describe '#domain' do
    subject { presenter.domain }
    let(:domain) { build(:domain) }
    it do
      is_expected.to be_a(DomainPresenter)
      expect(subject.user).to be user
      expect(subject.policy).to be_a(DomainsPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be_a(DomainPolicyAgent)
      expect(subject.policy.object_agent.client_type).to eq :Domain.to_s
      expect(subject.policy.object_agent.client).to be model.domain
      expect(subject.model).to be model.domain
    end
  end

  describe '#domains' do
    subject { presenter.domains }
    let(:domains) do
      [
          build(:domain, id: 0),
          build(:domain, id: 1),
          build(:domain, id: 2)
      ]
    end
    before { allow(Domain).to receive(:all).and_return(domains) }
    it do
      is_expected.to be_a(Array)
      expect(subject.count).to be domains.count
      subject.each.with_index do |domain, index|
        expect(domain[0]).to be domains[index].display_name
        expect(domain[1]).to be index
      end
    end
  end

  describe '#newspaper?' do
    subject { presenter.newspaper?(newspaper_presenter) }
    let(:newspaper_presenter) { nil }
    it { is_expected.to be false }
    context 'publisher' do
      let(:model) { create(:publisher, newspapers: newspapers) }
      let(:newspaper_presenter) { NewspaperPresenter.new(user, newspaper_policy, newspaper_model) }
      let(:newspaper_policy) { double('newspaper policy') }
      let(:newspaper_model) { build(:newspaper, id: 1) }
      it { is_expected.to be false }
      context 'publisher newspaper' do
        let(:newspapers) { [newspaper_model] }
        it { is_expected.to be true }
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
      expect(subject.user).to be user
      expect(subject.policy).to be_a(NewspapersPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be policy.object_agent
      expect(subject.count).to eq newspapers.count
      subject.each.with_index do |newspaper, index|
        expect(newspaper).to be_a(NewspaperPresenter)
        expect(newspaper.user).to be user
        expect(newspaper.policy).to be_a(NewspapersPolicy)
        expect(newspaper.policy.subject_agent).to be policy.subject_agent
        expect(newspaper.policy.object_agent).to be_a(NewspaperPolicyAgent)
        expect(newspaper.policy.object_agent.client_type).to eq :Newspaper.to_s
        expect(newspaper.policy.object_agent.client).to be newspapers[index]
        expect(newspaper.model).to be newspapers[index]
      end
    end
  end

  describe '#group?' do
    subject { presenter.group?(group_presenter) }
    let(:group_presenter) { nil }
    it { is_expected.to be false }
    context 'group' do
      let(:model) { create(:publisher, groups: groups) }
      let(:group_presenter) { GroupPresenter.new(user, group_policy, group_model) }
      let(:group_policy) { double('group policy') }
      let(:group_model) { build(:group, id: 1) }
      it { is_expected.to be false }
      context 'group member' do
        let(:groups) { [group_model] }
        it { is_expected.to be true }
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
    subject { presenter.user?(user_presenter) }
    let(:user_presenter) { nil }
    it { is_expected.to be false }
    context 'user' do
      let(:model) { create(:publisher, users: users) }
      let(:user_presenter) { UserPresenter.new(user, user_policy, user_model) }
      let(:user_policy) { double('user policy') }
      let(:user_model) { build(:user, id: 1) }
      it { is_expected.to be false }
      context 'user member' do
        let(:users) { [user_model] }
        it { is_expected.to be true }
      end
    end
  end

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
