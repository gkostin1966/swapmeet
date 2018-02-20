# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :listings
  validates :name, presence: true, allow_blank: false
  validates :display_name, presence: true, allow_blank: false
  validates :title, presence: true, allow_blank: false
end
