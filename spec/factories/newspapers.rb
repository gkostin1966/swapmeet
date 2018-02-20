# frozen_string_literal: true

FactoryBot.define do
  factory :newspaper do
    name "newspaper"
    display_name "Newspaper"
    publisher_id { create(:publisher).id }
  end
end
