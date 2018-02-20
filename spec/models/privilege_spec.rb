# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Privilege, type: :model do
  it { is_expected.to be_a(Privilege) }

  describe '#self.all' do
    subject { described_class.all }
    it { is_expected.to eq([]) }
    context 'gatekeeper' do
      let(:gatekeeper) { create(:gatekeeper, object_id: 1) }
      before { gatekeeper }
      it { expect(subject[0].id).to eq(gatekeeper.id) }
    end
  end
end
