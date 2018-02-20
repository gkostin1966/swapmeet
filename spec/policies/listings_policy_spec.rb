# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListingsPolicy do
  subject { policy }

  let(:policy) { ListingsPolicy.new(user, scope) }
  let(:scope)  { ->() { [] } }
  let(:user)   { create(:user) }

  context "with a known user" do
    it "allows index of listings" do
      expect(policy.index?).to be true
    end

    it "allows creation of a listing" do
      expect(policy.new?).to be true
    end
  end

  context "with a guest user" do
    let(:user) { User.guest }

    it "allows index of listings" do
      expect(policy.index?).to be true
    end

    it "disallows creation of a listing" do
      expect(policy.new?).to be false
    end
  end

  context "with a set of listings" do
    let(:listings) { [double('Listing'), double('Listing')] }
    let(:scope)    { double('Scope', to_a: listings) }

    it "resolves to the full set of listings" do
      expect(policy.resolve.to_a).to eq listings
    end
  end
end
