# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Listing do
  subject(:listing) { Listing.new }

  describe "#new" do
    it "starts with blank attributes" do
      expect(listing.id)   .to be_nil
      expect(listing.title).to be_nil
      expect(listing.body) .to be_nil
    end
  end

  it "supports setting and reading the title" do
    listing.title = 'Onyx Chop Sticks'
    expect(listing.title).to eq('Onyx Chop Sticks')
  end

  it "supports setting and reading the body" do
    listing.body = 'A fine pair of chop sticks, made of pure onyx.'
    expect(listing.body).to eq('A fine pair of chop sticks, made of pure onyx.')
  end
end
