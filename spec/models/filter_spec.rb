# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Filter, type: :model do
  subject { described_class.new(newspapers, owners, categories) }

  let(:newspapers) { [build(:newspaper)] }
  let(:owners) { [build(:user)] }
  let(:categories) { [build(:category)] }

  it { is_expected.to be_a(Filter) }
end
