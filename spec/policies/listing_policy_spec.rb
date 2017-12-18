# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListingPolicy, type: :policy do
  it_should_behave_like 'application policy'

  subject { policy }

  let(:policy) { ListingPolicy.new(PolicyAgent.new(:User, user), PolicyAgent.new(:Listing, listing)) }
  let(:user)       { User.new }
  let(:other_user) { User.new }
  let(:listing_owner)      { double('Listing Owner') }
  let(:listing) { create(:listing, owner: listing_owner) }

  context "when user is a guest" do
    let(:user) { User.guest }
    let(:listing_owner) { other_user }

    it "denies create" do
      expect(policy.create?).to be false
    end

    it "denies destroy" do
      expect(policy.destroy?).to be false
    end

    it "allows index" do
      expect(policy.index?).to be true
    end

    it "allows show" do
      expect(policy.show?).to be true
    end

    it "denies update" do
      expect(policy.update?).to be false
    end
  end

  context "when user is root" do
    let(:listing_owner) { other_user }

    before do
      allow(user).to receive(:persisted?).and_return(true)
      allow(user).to receive(:id).and_return(1)
    end

    it "allows create" do
      expect(policy.create?).to be true
    end

    it "allows destroy" do
      expect(policy.destroy?).to be true
    end

    it "allows index" do
      expect(policy.index?).to be true
    end

    it "allows show" do
      expect(policy.show?).to be true
    end

    it "allows update" do
      expect(policy.update?).to be true
    end
  end

  context "when user owns the listing" do
    let(:listing_owner) { user }

    it "allows create" do
      expect(policy.create?).to be true
    end

    it "allows destroy" do
      expect(policy.destroy?).to be true
    end

    it "allows index" do
      expect(policy.index?).to be true
    end

    it "allows show" do
      expect(policy.show?).to be true
    end

    it "allows update" do
      expect(policy.update?).to be true
    end
  end

  context "when a different user owns the listing" do
    let(:listing_owner) { other_user }

    it "denies create" do
      expect(policy.create?).to be false
    end

    it "denies destroy" do
      expect(policy.destroy?).to be false
    end

    it "allows index" do
      expect(policy.index?).to be true
    end

    it "allows show" do
      expect(policy.show?).to be true
    end

    it "denies update" do
      expect(policy.update?).to be false
    end
  end

  context "when nil owns the listing (should never happen, but might)" do
    let(:listing_owner) { nil }

    it "denies create" do
      expect(policy.create?).to be false
    end

    it "denies destroy" do
      expect(policy.destroy?).to be false
    end

    it "allows index" do
      expect(policy.index?).to be true
    end

    it "allows show" do
      expect(policy.show?).to be true
    end

    it "denies update" do
      expect(policy.update?).to be false
    end
  end
end
