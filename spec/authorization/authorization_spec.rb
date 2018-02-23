# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Authorization, type: :authorization do
  subject { authorization }

  let(:authorization) { described_class.new }

  it { is_expected.not_to be_nil }
end
