# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrivilegePresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, model) }
  let(:user) { build(:user) }
  let(:policy) { PrivilegesPolicy.new([SubjectPolicyAgent.new(:User, user), PrivilegePolicyAgent.new(model)]) }
  let(:model) { build(:privilege) }

  it { is_expected.to be_a(described_class) }

  context 'user delegation' do
    before do
    end
    it do
      expect(subject.user).to be user
    end
  end

  context 'policy delegation' do
    before do
    end
    it do
      expect(subject.policy).to be policy
    end
  end

  context 'model delegation' do
    before do
    end
    it do
      expect(subject.model).to be model
    end
  end
end
