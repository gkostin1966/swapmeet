# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  it_should_behave_like 'policy enforcer', :category, :Category

  describe '#new_policy' do
    it { expect(subject.send(:new_policy)).to be_a(CategoriesPolicy) }
  end
end
