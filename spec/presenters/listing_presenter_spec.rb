# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListingPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, model) }
  let(:user) { build(:user) }
  let(:policy) { ListingsPolicy.new([SubjectPolicyAgent.new(:User, user), ObjectPolicyAgent.new(:Listing, model)]) }
  let(:model) { build(:listing, title: title, owner: owner, category: category, newspaper: newspaper) }
  let(:title) { nil }
  let(:owner) { nil }
  let(:category) { nil }
  let(:newspaper) { nil }

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
      expect(subject.title).to be model.title
      expect(subject.body).to be model.body
    end
  end

  describe '#label' do
    subject { presenter.label }
    it { is_expected.to be_a(String) }
    context 'blank' do
      let(:title) { nil }
      it { is_expected.to eq 'LISTING' }
    end
    context 'present' do
      let(:title) { 'title' }
      it { is_expected.to eq model.title }
    end
  end

  describe '#category?' do
    subject { presenter.category? }
    context 'blank' do
      let(:category) { nil }
      it { is_expected.to be false }
    end
    context 'present' do
      let(:category) { build(:category) }
      it { is_expected.to be true }
    end
  end

  describe '#category' do
    subject { presenter.category }
    let(:category) { build(:category) }
    it do
      is_expected.to be_a(CategoryPresenter)
      expect(subject.user).to be user
      expect(subject.policy).to be_a(CategoriesPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be_a(ObjectPolicyAgent)
      expect(subject.policy.object_agent.client_type).to eq :Category.to_s
      expect(subject.policy.object_agent.client).to be model.category
      expect(subject.model).to be category
    end
  end

  describe '#categories' do
    subject { presenter.categories }
    let(:categories) do
      [
          build(:category, id: 0),
          build(:category, id: 1),
          build(:category, id: 2)
      ]
    end
    before { allow(Category).to receive(:all).and_return(categories) }
    it do
      is_expected.to be_a(Array)
      expect(subject.count).to be categories.count
      subject.each.with_index do |category, index|
        expect(category[0]).to be categories[index].display_name
        expect(category[1]).to be index
      end
    end
  end

  describe '#newspaper?' do
    subject { presenter.newspaper? }
    context 'blank' do
      let(:newspaper) { nil }
      it { is_expected.to be false }
    end
    context 'present' do
      let(:newspaper) { build(:newspaper) }
      it { is_expected.to be true }
    end
  end

  describe '#newspaper' do
    subject { presenter.newspaper }
    let(:newspaper) { build(:newspaper) }
    it do
      is_expected.to be_a(NewspaperPresenter)
      expect(subject.user).to be user
      expect(subject.policy).to be_a(NewspapersPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be_a(ObjectPolicyAgent)
      expect(subject.policy.object_agent.client_type).to eq :Newspaper.to_s
      expect(subject.policy.object_agent.client).to be model.newspaper
      expect(subject.model).to be model.newspaper
    end
  end

  describe '#newspapers' do
    subject { presenter.newspapers }
    let(:newspapers) do
      [
          build(:newspaper, id: 0),
          build(:newspaper, id: 1),
          build(:newspaper, id: 2)
      ]
    end
    before { allow(Newspaper).to receive(:all).and_return(newspapers) }
    it do
      is_expected.to be_a(Array)
      expect(subject.count).to be newspapers.count
      subject.each.with_index do |newspaper, index|
        expect(newspaper[0]).to be newspapers[index].display_name
        expect(newspaper[1]).to be index
      end
    end
  end

  describe '#owner?' do
    subject { presenter.owner? }
    context 'blank' do
      let(:owner) { nil }
      it { is_expected.to be false }
    end
    context 'present' do
      let(:owner) { build(:user) }
      it { is_expected.to be true }
    end
  end

  describe '#owner' do
    subject { presenter.owner }
    let(:owner) { build(:user) }
    it do
      is_expected.to be_a(UserPresenter)
      expect(subject.user).to be user
      expect(subject.policy).to be_a(UsersPolicy)
      expect(subject.policy.subject_agent).to be policy.subject_agent
      expect(subject.policy.object_agent).to be_a(ObjectPolicyAgent)
      expect(subject.policy.object_agent.client_type).to eq :User.to_s
      expect(subject.policy.object_agent.client).to be model.owner
      expect(subject.model).to be model.owner
    end
  end
end
