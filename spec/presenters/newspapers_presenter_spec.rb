# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewspapersPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, models) }
  let(:user) { build(:user) }
  let(:policy) { NewspapersPolicy.new([SubjectPolicyAgent.new(:User, user), nil]) }
  let(:models) { newspapers }
  let(:newspapers) do
    [
        build(:newspaper),
        build(:newspaper),
        build(:newspaper)
    ]
  end

  it { is_expected.to be_a(described_class) }

  describe 'presenters' do
    subject { presenter.presenters }
    it do
      is_expected.to be_a(Array)
      expect(subject.count).to eq models.count
      subject.each.with_index do |model_presenter, index|
        expect(model_presenter).to be_a(NewspaperPresenter)
        expect(model_presenter.user).to be user
        expect(model_presenter.policy).to be_a(NewspapersPolicy)
        expect(model_presenter.policy.subject_agent).to be policy.subject_agent
        expect(model_presenter.policy.object_agent).to be_a(NewspaperPolicyAgent)
        expect(model_presenter.policy.object_agent.client_type).to eq :Newspaper.to_s
        expect(model_presenter.policy.object_agent.client).to be newspapers[index]
        expect(model_presenter.model).to be newspapers[index]
      end
    end
  end
end
