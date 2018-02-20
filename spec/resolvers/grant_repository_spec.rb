# frozen_string_literal: true

require 'grant_repository'

RSpec.describe GrantRepository do
  it "does not have any grants" do
    expect(subject.grants_for(nil, nil, nil)).to eq([])
  end
end
