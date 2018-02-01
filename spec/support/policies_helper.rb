# frozen_string_literal: true

module PoliciesHelper
  ENTITY_TYPES = %i[Category Domain Group Listing Newspaper Publisher User]
end

RSpec.shared_examples 'an application policy' do
  subject { described_class.new([subject_agent, object_agent]) }

  let(:subject_agent) { double('subject agent') }
  let(:object_agent) { double('object agent') }

  it 'is an application policy' do
    is_expected.to be_a ApplicationPolicy
  end

  it 'aliases new?' do
    is_expected.to receive(:create?)
    subject.new?
  end

  it 'aliases edit?' do
    is_expected.to receive(:update?)
    subject.edit?
  end
end
