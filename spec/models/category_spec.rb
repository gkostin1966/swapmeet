# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  describe '#new' do
    context 'default' do
      subject { described_class.new }
      it do
        is_expected.not_to be_nil
        is_expected.to be_a Category
        expect(subject.name).to be_nil
        expect(subject.display_name).to be_nil
        expect(subject.title).to be_nil
      end
    end
    context 'create' do
      subject { create(:category, name: 'Name', display_name: 'Display Name', title: 'Title') }
      it do
        is_expected.not_to be_nil
        is_expected.to be_a Category
        expect(subject.name).to eq 'Name'
        expect(subject.display_name).to eq 'Display Name'
        expect(subject.title).to eq 'Title'
      end
    end
  end
end
