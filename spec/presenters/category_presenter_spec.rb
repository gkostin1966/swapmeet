# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoryPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, model) }
  let(:user) { build(:user) }
  let(:policy) { CategoriesPolicy.new(SubjectPolicyAgent.new(:User, user), CategoryPolicyAgent.new(model)) }
  let(:model) { build(:category, listings: listings) }
  let(:listings) { [] }

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
      expect(subject.title).to be model.title
    end
  end

  describe '#label' do
    subject { presenter.label }
    it do
      is_expected.to be_a(String)
      is_expected.to eq model.display_name
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
      expect(subject.policy.subject).to be policy.subject
      expect(subject.policy.object).to be policy.object
      expect(subject.count).to eq listings.count
      subject.each.with_index do |listing, index|
        expect(listing).to be_a(ListingPresenter)
        expect(listing.user).to be user
        expect(listing.policy).to be_a(ListingPolicy)
        expect(listing.policy.subject).to be policy.subject
        expect(listing.policy.object).to be_a(ListingPolicyAgent)
        expect(listing.policy.object.client_type).to eq :Listing.to_s
        expect(listing.policy.object.client).to be listings[index]
        expect(listing.model).to be listings[index]
      end
    end
  end
end
