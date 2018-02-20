# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationsPresenter do
  subject { presenter }

  let(:presenter) { described_class.new(user, policy, models, presenters) }
  let(:user) { double('user') }
  let(:policy) { double('policy') }
  let(:models) { double('models') }
  let(:presenters) { double('presenters') }

  it do
    is_expected.to be_a(described_class)
    expect(presenter.user).to be user
    expect(presenter.policy).to be policy
    expect(presenter.models).to be models
    expect(presenter.presenters).to be presenters
  end
end
