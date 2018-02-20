# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrivilegesPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, models) }
  let(:user) { build(:user) }
  let(:policy) { PrivilegesPolicy.new([SubjectPolicyAgent.new(:User, user), nil]) }
  let(:models) { privileges }
  let(:privileges) do
    [
    ]
  end

  it { is_expected.to be_a(described_class) }

  describe 'presenters' do
    subject { presenter.presenters }
    it do
      is_expected.to be_a(Array)
      expect(subject.count).to eq models.count
      subject.each.with_index do |model_presenter, index|
        expect(model_presenter).to be_a(PrivilegePresenter)
        expect(model_presenter.user).to be user
        expect(model_presenter.policy).to be_a(PrivilegesPolicy)
        expect(model_presenter.policy.subject_agent).to be policy.subject_agent
        expect(model_presenter.policy.object_agent).to be_a(PrivilegePolicyAgent)
        expect(model_presenter.policy.object_agent.client_type).to eq :Privilege.to_s
        expect(model_presenter.policy.object_agent.client).to be privileges[index]
        expect(model_presenter.model).to be privileges[index]
      end
    end
  end
end
