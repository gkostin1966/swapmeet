# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Listing, type: :model do
  describe '#new' do
    context 'new' do
      subject { described_class.new }
      it do
        is_expected.not_to be_nil
        is_expected.to be_a Listing
        expect(subject.title).to be_nil
        expect(subject.body).to be_nil
        expect(subject.owner_id).to be_nil
        expect(subject.newspaper_id).to be_nil
        expect(subject.category_id).to be_nil
      end
    end
    context 'create' do
      subject { create(:listing, title: 'Title', body: 'Body') }
      it do
        is_expected.not_to be_nil
        is_expected.to be_a Listing
        expect(subject.title).to eq 'Title'
        expect(subject.body).to eq 'Body'
        expect(subject.owner_id).not_to be_nil
        expect(subject.newspaper_id).not_to be_nil
        expect(subject.category_id).not_to be_nil
      end
    end
  end
end
