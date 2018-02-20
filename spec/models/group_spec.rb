# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group, type: :model do
  describe '#new' do
    context 'default' do
      subject { described_class.new }
      it do
        is_expected.not_to be_nil
        is_expected.to be_a Group
        expect(subject.name).to be_nil
        expect(subject.display_name).to be_nil
        expect(subject.parent_id).to be_nil
      end
    end
    context 'create' do
      subject { create(:group, name: 'Name', display_name: 'Display Name') }
      it do
        is_expected.not_to be_nil
        is_expected.to be_a Group
        expect(subject.name).to eq 'Name'
        expect(subject.display_name).to eq 'Display Name'
        expect(subject.parent_id).to be_nil
      end
    end
  end
end
