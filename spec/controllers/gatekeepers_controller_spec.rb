# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GatekeepersController, type: :controller do
  it_should_behave_like 'policy enforcer', :gatekeeper, :Gatekeeper

  describe '#new_policy' do
    it { expect(subject.send(:new_policy)).to be_a(GatekeepersPolicy) }
  end
end
