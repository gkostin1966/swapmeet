# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authorization, type: :authorization do
  subject { authorization }

  let(:authorization) { described_class.new(user, action, target) }
  let(:user) { double('user') }
  let(:action) { double('action') }
  let(:target) { double('target') }

  describe '#permit?' do
    subject { authorization.permit? }

    it { is_expected.to be false }

    context 'permit' do
      xit { is_expected.to be true }
    end
  end
end
