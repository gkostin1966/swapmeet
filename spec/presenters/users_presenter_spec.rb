# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, models) }
  let(:user) { build(:user) }
  let(:policy) { UsersPolicy.new([SubjectPolicyAgent.new(:User, user), nil]) }
  let(:models) { users }
  let(:users) do
    [
        build(:user),
        build(:user),
        build(:user)
    ]
  end

  it { is_expected.to be_a(described_class) }

  describe 'presenters' do
    subject { presenter.presenters }
    it do
      is_expected.to be_a(Array)
      expect(subject.count).to eq models.count
      subject.each.with_index do |model_presenter, index|
        expect(model_presenter).to be_a(UserPresenter)
        expect(model_presenter.user).to be user
        expect(model_presenter.policy).to be_a(UsersPolicy)
        expect(model_presenter.policy.subject_agent).to be policy.subject_agent
        expect(model_presenter.policy.object_agent).to be_a(UserPolicyAgent)
        expect(model_presenter.policy.object_agent.client_type).to eq :User.to_s
        expect(model_presenter.policy.object_agent.client).to be users[index]
        expect(model_presenter.model).to be users[index]
      end
    end
  end
end
