# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RootPolicy, type: :policy do
  it_should_behave_like 'an application policy'

  describe '#method_missing' do
    subject { described_class.new([nil, nil]) }
    it { expect(subject.action?).to be true }
    it { expect { subject.action }.to raise_error(NoMethodError) }
  end
end
