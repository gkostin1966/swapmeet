# frozen_string_literal: true

FactoryBot.define do
  factory :listing do
    title "title"
    body "body"
    category { create(:category) }
    newspaper { create(:newspaper) }
    owner { create(:user) }
  end
end
