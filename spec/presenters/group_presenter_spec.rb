# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, model) }
  let(:user) { build(:user) }
  let(:policy) { GroupsPolicy.new(SubjectPolicyAgent.new(:User, user), GroupPolicyAgent.new(model)) }
  let(:model) { build(:group, display_name: display_name, parent: parent, children: children, users: users, publishers: publishers, newspapers: newspapers) }
  let(:display_name) { nil }
  let(:parent) { nil }
  let(:children) { [] }
  let(:users) { [] }
  let(:publishers) { [] }
  let(:newspapers) { [] }

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
      it { is_expected.to eq 'GROUP' }
    end
    context 'present' do
      let(:display_name) { 'display_name' }
      it { is_expected.to eq model.display_name }
    end
  end

  describe '#parent?' do
    subject { presenter.parent? }
    context 'blank' do
      let(:parent) { nil }
      it { is_expected.to be false }
    end
    context 'present' do
      let(:parent) { build(:group) }
      it { is_expected.to be true }
    end
  end

  describe '#parent' do
    subject { presenter.parent }
    let(:parent) { build(:group) }
    it do
      is_expected.to be_a(GroupPresenter)
      expect(subject.user).to be user
      expect(subject.policy).to be_a(GroupsPolicy)
      expect(subject.policy.subject).to be policy.subject
      expect(subject.policy.object).to be_a(GroupPolicyAgent)
      expect(subject.policy.object.client_type).to eq :Group.to_s
      expect(subject.policy.object.client).to be model.parent
      expect(subject.model).to be model.parent
    end
  end

  describe '#child?' do
    subject { presenter.child?(object_presenter) }
    let(:object_presenter) { ApplicationPresenter.new(user, object_policy, object_model) }
    let(:object_policy) { ApplicationPolicy.new(user, ObjectPolicyAgent.new(:Object, object_model)) }
    let(:object_model) { double('object model', groups: object_groups) }
    let(:object_groups) { double('object groups') }
    let(:boolean) { double('boolean') }
    before { allow(object_groups).to receive(:exists?).with(policy.object.client.id).and_return(boolean) }
    it { is_expected.to be boolean }
  end

  describe '#add?' do
    subject { presenter.add?(object_presenter) }
    let(:object_presenter) { ApplicationPresenter.new(user, object_policy, object_model) }
    let(:object_policy) { ApplicationPolicy.new(user, ObjectPolicyAgent.new(:Object, object_model)) }
    let(:object_model) { double('object model') }
    let(:boolean) { double('boolean') }
    before { allow(object_policy).to receive(:add?).with(policy.object).and_return(boolean) }
    it { is_expected.to be boolean }
  end

  describe '#remove?' do
    subject { presenter.remove?(object_presenter) }
    let(:object_presenter) { ApplicationPresenter.new(user, object_policy, object_model) }
    let(:object_policy) { ApplicationPolicy.new(user, ObjectPolicyAgent.new(:Object, object_model)) }
    let(:object_model) { double('object model') }
    let(:boolean) { double('boolean') }
    before { allow(object_policy).to receive(:remove?).with(policy.object).and_return(boolean) }
    it { is_expected.to be boolean }
  end

  describe '#children?' do
    subject { presenter.children? }
    context 'empty' do
      let(:children) { [] }
      it { is_expected.to be false }
    end
    context '!empty' do
      let(:children) { [build(:group)] }
      it { is_expected.to be true }
    end
  end

  describe '#children' do
    subject { presenter.children }
    let(:children) do
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
      expect(subject.policy.subject).to be policy.subject
      expect(subject.policy.object).to be policy.object
      expect(subject.count).to eq children.count
      subject.each.with_index do |group, index|
        expect(group).to be_a(GroupPresenter)
        expect(group.user).to be user
        expect(group.policy).to be_a(GroupsPolicy)
        expect(group.policy.subject).to be policy.subject
        expect(group.policy.object).to be_a(GroupPolicyAgent)
        expect(group.policy.object.client_type).to eq :Group.to_s
        expect(group.policy.object.client).to be children[index]
        expect(group.model).to be children[index]
      end
    end
  end

  describe '#groups' do
    subject { presenter.groups }
    let(:groups) do
      [
          build(:group, id: 0),
          build(:group, id: 1),
          build(:group, id: 2)
      ]
    end
    before { allow(Group).to receive(:all).and_return(groups) }
    it do
      is_expected.to be_a(Array)
      expect(subject.count).to be groups.count
      subject.each.with_index do |group, index|
        expect(group[0]).to be groups[index].display_name
        expect(group[1]).to be index
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
      expect(subject.user).to be user
      expect(subject.policy).to be_a(PublishersPolicy)
      expect(subject.policy.subject).to be policy.subject
      expect(subject.policy.object).to be policy.object
      expect(subject.count).to eq publishers.count
      subject.each.with_index do |publisher, index|
        expect(publisher).to be_a(PublisherPresenter)
        expect(publisher.user).to be user
        expect(publisher.policy).to be_a(PublishersPolicy)
        expect(publisher.policy.subject).to be policy.subject
        expect(publisher.policy.object).to be_a(PublisherPolicyAgent)
        expect(publisher.policy.object.client_type).to eq :Publisher.to_s
        expect(publisher.policy.object.client).to be publishers[index]
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
      expect(subject.user).to be user
      expect(subject.policy).to be_a(NewspapersPolicy)
      expect(subject.policy.subject).to be policy.subject
      expect(subject.policy.object).to be policy.object
      expect(subject.count).to eq newspapers.count
      subject.each.with_index do |newspaper, index|
        expect(newspaper).to be_a(NewspaperPresenter)
        expect(newspaper.user).to be user
        expect(newspaper.policy).to be_a(NewspapersPolicy)
        expect(newspaper.policy.subject).to be policy.subject
        expect(newspaper.policy.object).to be_a(NewspaperPolicyAgent)
        expect(newspaper.policy.object.client_type).to eq :Newspaper.to_s
        expect(newspaper.policy.object.client).to be newspapers[index]
        expect(newspaper.model).to be newspapers[index]
      end
    end
  end

  describe '#user?' do
    subject { presenter.user?(usr) }
    let(:user) { build(:user) }
    let(:model) { create(:group, users: users) }
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
      expect(subject.policy.subject).to be policy.subject
      expect(subject.policy.object).to be policy.object
      expect(subject.count).to eq users.count
      subject.each.with_index do |usr, index|
        expect(usr).to be_a(UserPresenter)
        expect(usr.user).to be user
        expect(usr.policy).to be_a(UsersPolicy)
        expect(usr.policy.subject).to be policy.subject
        expect(usr.policy.object).to be_a(UserPolicyAgent)
        expect(usr.policy.object.client_type).to eq :User.to_s
        expect(usr.policy.object.client).to be users[index]
        expect(usr.model).to be users[index]
      end
    end
  end
end
