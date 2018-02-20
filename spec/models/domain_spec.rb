# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domain, type: :model do
  describe '#new' do
    context 'default' do
      subject { described_class.new }
      it do
        is_expected.not_to be_nil
        is_expected.to be_a Domain
        expect(subject.name).to be_nil
        expect(subject.display_name).to be_nil
        expect(subject.parent_id).to be_nil
      end
    end
    context 'create' do
      subject { create(:domain, name: 'Name', display_name: 'Display Name') }
      it do
        is_expected.not_to be_nil
        is_expected.to be_a Domain
        expect(subject.name).to eq 'Name'
        expect(subject.display_name).to eq 'Display Name'
        expect(subject.parent_id).to be_nil
      end
    end
  end
end
